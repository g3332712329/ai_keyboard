package com.dboy.ai_keyboard.ui.keyboard.style

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.updateLayoutParams
import com.dboy.ai_keyboard.config.ReplyStyle
import com.dboy.ai_keyboard.databinding.FragmentStyleGridBinding

/**
 * 单页 3x3 风格网格自定义 View。
 *
 * 内部使用 ConstraintLayout Flow 实现均分网格，
 * 配合 [StylePagerAdapter] 在 ViewPager2 中展示。
 */
class StylePageView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
) : ConstraintLayout(context, attrs, defStyleAttr) {

    private val binding = FragmentStyleGridBinding.inflate(
        LayoutInflater.from(context),
        this,
        true,
    )

    private val styleViews: List<TextView> = listOf(
        binding.style0,
        binding.style1,
        binding.style2,
        binding.style3,
        binding.style4,
        binding.style5,
        binding.style6,
        binding.style7,
        binding.style8,
    )

    private var onStyleClick: ((ReplyStyle) -> Unit)? = null

    /**
     * 绑定本页风格数据。
     *
     * @param pageStyles 最多 9 个风格
     * @param generatingStyleId 当前正在生成的风格 ID
     * @param isBusy 是否整体处于生成中（用于禁用其他按钮）
     * @param listener 风格点击回调
     */
    fun bind(
        pageStyles: List<ReplyStyle>,
        generatingStyleId: Int?,
        isBusy: Boolean,
        listener: (ReplyStyle) -> Unit,
    ) {
        onStyleClick = listener
        var generatingView: TextView? = null

        styleViews.forEachIndexed { index, textView ->
            if (index < pageStyles.size) {
                val style = pageStyles[index]
                val isGenerating = style.id == generatingStyleId

                textView.visibility = VISIBLE
                textView.text = if (isGenerating) "" else style.name
                textView.isEnabled = !isBusy || isGenerating
                textView.alpha = if (textView.isEnabled) 1.0f else 0.5f
                textView.setOnClickListener {
                    if (!isBusy) {
                        listener(style)
                    }
                }

                if (isGenerating) {
                    generatingView = textView
                }
            } else {
                textView.visibility = INVISIBLE
                textView.setOnClickListener(null)
            }
        }

        if (generatingView != null) {
            binding.pbLoadingView.visibility = VISIBLE
            binding.pbLoadingView.updateLayoutParams<LayoutParams> {
                startToStart = generatingView.id
                endToEnd = generatingView.id
                topToTop = generatingView.id
                bottomToBottom = generatingView.id
            }
        } else {
            binding.pbLoadingView.visibility = GONE
        }
    }
}
