package com.dboy.ai_keyboard

import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.ExtractedTextRequest
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.updatePadding
import androidx.lifecycle.ViewModelProvider
import com.dboy.ai_keyboard.base.BaseInputMethodService
import com.dboy.ai_keyboard.databinding.KeyboardLayoutBinding
import com.dboy.ai_keyboard.repository.ConfigurationRepository
import com.dboy.ai_keyboard.repository.LocalConfigurationRepository
import com.dboy.ai_keyboard.repository.openai.AiRepository
import com.dboy.ai_keyboard.repository.openai.OpenAiRepository
import com.dboy.ai_keyboard.ui.keyboard.KeyboardEffect
import com.dboy.ai_keyboard.ui.keyboard.KeyboardEvent
import com.dboy.ai_keyboard.ui.keyboard.KeyboardState
import com.dboy.ai_keyboard.ui.keyboard.KeyboardViewModel
import com.dboy.ai_keyboard.ui.keyboard.style.StylePagerAdapter
import com.dboy.ai_keyboard.utils.MmkvSharesLocalData
import com.dboy.ai_keyboard.utils.SharesLocalData

/**
 * AI 回复键盘输入法服务，作为 MVI 中的 View 层。
 *
 * 负责：
 * - 把用户操作转成 [KeyboardEvent] 发送给 [KeyboardViewModel]
 * - 观察 [KeyboardState] 并刷新键盘 UI
 * - 消费 [KeyboardEffect] 操作宿主输入框或显示提示
 *
 * 所有 UI 刷新和输入框操作前，都会通过 [isInputViewShown] 判断键盘是否仍然显示，
 * 避免键盘收起后还继续操作输入框导致异常。
 */
class AiKeyboardService : BaseInputMethodService() {

    private lateinit var viewBinding: KeyboardLayoutBinding
    private lateinit var stylePagerAdapter: StylePagerAdapter

    /**
     * 本地存储工具，延迟初始化。
     */
    private val localDataUtil: SharesLocalData by lazy {
        MmkvSharesLocalData()
    }

    /**
     * 配置仓库，延迟初始化。
     */
    private val configurationRepository: ConfigurationRepository by lazy {
        LocalConfigurationRepository(localDataUtil)
    }

    /**
     * AI 请求仓库，使用 openai-kotlin。
     *
     * 传入本地存储实例，让仓库能读取 Flutter 端写入的 AI 角色提示词模板。
     */
    private val aiRepository: AiRepository by lazy {
        OpenAiRepository(localDataUtil)
    }

    /**
     * 键盘业务 ViewModel，跟随 Service 生命周期。
     */
    private val keyboardViewModel: KeyboardViewModel by lazy {
        ViewModelProvider(
            this,
            KeyboardViewModel.Factory(configurationRepository, aiRepository),
        )[KeyboardViewModel::class.java]
    }

    // region 生命周期：创建与销毁

    override fun onCreate() {
        super.onCreate()
        localDataUtil.init(this)
    }

    // endregion

    // region 生命周期：键盘 UI 创建

    override fun onCreateInputView(): View {
        viewBinding = KeyboardLayoutBinding.inflate(LayoutInflater.from(this))
        setupViews()
        observeViewModel()


        ViewCompat.setOnApplyWindowInsetsListener(viewBinding.root) { view, insets ->
            val bottomInset = insets.getInsets(
                WindowInsetsCompat.Type.navigationBars() or WindowInsetsCompat.Type.ime()
            ).bottom
            // 避免系统按键遮挡键盘底部内容
            view.updatePadding(bottom = bottomInset+8.dpToPx())
            view.parent.requestLayout()
            insets
        }

        return viewBinding.root
    }

    /**
     * 初始化各个按钮和 ViewPager2。
     */
    private fun setupViews() {
        stylePagerAdapter = StylePagerAdapter()
        stylePagerAdapter.setOnStyleClickListener { style ->
            keyboardViewModel.onEvent(KeyboardEvent.GenerateReply(style))
        }
        viewBinding.vpStyleContainer.adapter = stylePagerAdapter

        viewBinding.btnSwitchKeyboard.setOnClickListener {
            showInputMethodPicker()
        }
        viewBinding.btnPaste.setOnClickListener {
            handlePaste()
        }
        viewBinding.btnDelete.setOnClickListener {
            handleDelete()
        }
        viewBinding.btnClear.setOnClickListener {
            handleClear()
        }
        viewBinding.btnSend.setOnClickListener {
            handleSend()
        }
    }

    /**
     * 观察 ViewModel 的状态和副作用。
     */
    private fun observeViewModel() {
        keyboardViewModel.stateLiveData.observe(this) { state ->
            if (isInputViewShown) {
                renderState(state)
            }
        }

        keyboardViewModel.effectLiveData.observe(this) { effect ->
            if (isInputViewShown) {
                handleEffect(effect)
            }
        }
    }

    // endregion

    // region 生命周期：输入开始与结束

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        // 每次软键盘弹出时刷新配置和风格数据
        keyboardViewModel.onEvent(KeyboardEvent.LoadConfig)
    }

    // endregion

    // region UI 渲染

    /**
     * 根据最新状态刷新键盘界面。
     */
    private fun renderState(state: KeyboardState) {
        viewBinding.tvInput.text = state.inputText

        if (stylePagerAdapter.itemCount == 0 || state.styles.isNotEmpty()) {
            stylePagerAdapter.submitStyles(state.styles)
        }
        stylePagerAdapter.setGeneratingStyleId(state.generatingStyleId)

        viewBinding.pbLoadingView.visibility = if (state.isLoading) View.VISIBLE else View.GONE

        val isBusy = state.generatingStyleId != null
        viewBinding.btnPaste.isEnabled = !isBusy
        viewBinding.btnDelete.isEnabled = !isBusy
        viewBinding.btnClear.isEnabled = !isBusy
        viewBinding.btnSend.isEnabled = !isBusy
    }

    // endregion

    // region 副作用处理

    /**
     * 处理来自 ViewModel 的一次性副作用。
     */
    private fun handleEffect(effect: KeyboardEffect) {
        when (effect) {
            is KeyboardEffect.CommitText -> {
                currentInputConnection?.commitText(effect.text, 1)
                if (effect.autoSend) {
                    sendCurrentInputAction()
                }
            }

            is KeyboardEffect.ShowToast -> {
                Toast.makeText(this, effect.message, Toast.LENGTH_SHORT).show()
            }

            is KeyboardEffect.SwitchIme -> {
                showInputMethodPicker()
            }
        }
    }

    // endregion

    // region 用户操作：在 UI 层直接处理

    /**
     * 读取剪贴板内容并交给 ViewModel 追加到输入框。
     */
    private fun handlePaste() {
        val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val text = clipboard.primaryClip?.getItemAt(0)?.text?.toString().orEmpty()
        keyboardViewModel.onEvent(KeyboardEvent.PasteContent(text))
    }

    /**
     * 删除宿主输入框光标前的一个字符。
     */
    private fun handleDelete() {
        currentInputConnection?.deleteSurroundingTextInCodePoints(1, 0)
    }

    /**
     * 清空宿主输入框中的全部文本。
     */
    private fun handleClear() {
        val ic = currentInputConnection ?: return
        val extracted = ic.getExtractedText(ExtractedTextRequest(), 0)
        val length = extracted?.text?.length ?: return
        ic.setSelection(0, length)
        ic.commitText("", 1)
    }

    /**
     * 触发宿主输入框的当前提交动作（发送/完成）。
     */
    private fun handleSend() {
        sendCurrentInputAction()
    }

    /**
     * 根据当前输入框的 EditorInfo 触发对应的 editor action。
     */
    private fun sendCurrentInputAction() {
        val editorInfo = currentInputEditorInfo
        val actionId = editorInfo?.actionId ?: EditorInfo.IME_ACTION_DONE
//            ?: (editorInfo?.imeOptions?.and(EditorInfo.IME_MASK_ACTION))
//            ?: EditorInfo.IME_ACTION_DONE

        currentInputConnection?.performEditorAction(actionId)
    }

    /**
     * 显示系统输入法选择器弹窗。
     *
     * 注意：这是弹出选择框让用户手动切换，
     * 和 [InputMethodManager.switchToNextInputMethod] 的直接切换不同。
     */
    private fun showInputMethodPicker() {
        val inputMethodManager = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
        inputMethodManager.showInputMethodPicker()
    }

    // endregion

    private fun Int.dpToPx(): Int = (this * resources.displayMetrics.density).toInt()

}
