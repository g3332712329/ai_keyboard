package com.dboy.ai_keyboard.ui.keyboard

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.asLiveData
import androidx.lifecycle.viewModelScope
import com.dboy.ai_keyboard.config.APP_PREFERENCE_KEY_AUTO_SEND
import com.dboy.ai_keyboard.config.AiPlatform
import com.dboy.ai_keyboard.config.DefaultConfig
import com.dboy.ai_keyboard.config.ReplyStyle
import com.dboy.ai_keyboard.repository.ConfigurationRepository
import com.dboy.ai_keyboard.repository.openai.AiRepository
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/**
 * 键盘页面 ViewModel，按 MVI 模式组织。
 *
 * - [state] 是单一事实来源，驱动 UI 刷新。
 * - [effect] 是一次性副作用，由 View 层消费。
 * - [onEvent] 接收 View 层发送的用户意图。
 */
class KeyboardViewModel(
    private val configurationRepository: ConfigurationRepository,
    private val aiRepository: AiRepository,
) : ViewModel() {

    private val _state = MutableStateFlow(KeyboardState())
    val state: StateFlow<KeyboardState> = _state.asStateFlow()

    /**
     * 给习惯 LiveData 的 View 层使用，底层仍然是同一个 StateFlow。
     */
    val stateLiveData: LiveData<KeyboardState> = state.asLiveData()

    private val _effect = MutableSharedFlow<KeyboardEffect>()
    val effect: SharedFlow<KeyboardEffect> = _effect.asSharedFlow()

    /**
     * LiveData 版本的副作用，方便 Service 直接观察。
     */
    val effectLiveData: LiveData<KeyboardEffect> = effect.asLiveData()

    /**
     * 处理用户意图。
     *
     * @param event 来自 View 层的事件
     */
    fun onEvent(event: KeyboardEvent) {
        when (event) {
            is KeyboardEvent.LoadConfig -> loadConfig()
            is KeyboardEvent.PasteContent -> pasteContent(event.text)
            is KeyboardEvent.GenerateReply -> generateReply(event.style)
            is KeyboardEvent.ClearError -> clearError()
        }
    }

    /**
     * 加载本地配置，刷新风格列表、平台和偏好设置。
     */
    private fun loadConfig() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true) }

            val config = try {
                configurationRepository.getConfiguration()
            } catch (e: Exception) {
                _state.update {
                    it.copy(
                        isLoading = false,
                        errorMessage = "配置读取失败：${e.message}",
                    )
                }
                return@launch
            }

            val styles = config.replyStyles.ifEmpty { DefaultConfig.replyStyles }
            val selectedPlatform = config.platforms.firstOrNull { it.enable }
            val autoSend = config.preferences
                .firstOrNull { it.key == APP_PREFERENCE_KEY_AUTO_SEND }
                ?.isOpen
                ?: false

            _state.update {
                it.copy(
                    styles = styles,
                    selectedPlatform = selectedPlatform,
                    autoSend = autoSend,
                    isLoading = false,
                )
            }
        }
    }

    /**
     * 把剪贴板内容追加到输入框文本末尾。
     *
     * @param text 剪贴板读取到的文本
     */
    private fun pasteContent(text: String) {
        if (text.isBlank()) {
            sendEffect(KeyboardEffect.ShowToast("剪贴板为空"))
            return
        }
        _state.update { current ->
            val prefix = if (current.inputText.isBlank()) "" else "${current.inputText}\n"
            current.copy(inputText = prefix + text)
        }
    }

    /**
     * 根据当前输入内容和风格生成 AI 回复。
     *
     * @param style 选中的回复风格
     */
    private fun generateReply(style: ReplyStyle) {
        val currentState = _state.value
        if (currentState.inputText.isBlank()) {
            sendEffect(KeyboardEffect.ShowToast("请先粘贴对话内容"))
            return
        }
        if (currentState.generatingStyleId != null) {
            return
        }
        val platform = currentState.selectedPlatform
        if (platform == null) {
            sendEffect(KeyboardEffect.ShowToast("未配置可用的 AI 平台"))
            return
        }

        viewModelScope.launch {
            _state.update { it.copy(generatingStyleId = style.id) }

            val result = aiRepository.generateReply(
                input = currentState.inputText,
                style = style,
                platform = platform,
            )

            _state.update { it.copy(generatingStyleId = null) }

            result.fold(
                onSuccess = { reply ->
                    sendEffect(
                        KeyboardEffect.CommitText(
                            text = reply,
                            autoSend = currentState.autoSend,
                        )
                    )
                },
                onFailure = { error ->
                    _state.update {
                        it.copy(errorMessage = "生成失败：${error.message}")
                    }
                },
            )
        }
    }

    private fun clearError() {
        _state.update { it.copy(errorMessage = null) }
    }

    private fun sendEffect(newEffect: KeyboardEffect) {
        viewModelScope.launch {
            _effect.emit(newEffect)
        }
    }

    /**
     * ViewModel 工厂，用于带参数创建实例。
     */
    class Factory(
        private val configurationRepository: ConfigurationRepository,
        private val aiRepository: AiRepository,
    ) : ViewModelProvider.Factory {

        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            if (modelClass.isAssignableFrom(KeyboardViewModel::class.java)) {
                return KeyboardViewModel(configurationRepository, aiRepository) as T
            }
            throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
        }
    }
}
