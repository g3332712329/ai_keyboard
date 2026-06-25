package com.dboy.ai_keyboard.ui.keyboard.style

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dboy.ai_keyboard.config.ReplyStyle

/**
 * 风格网格 ViewPager2 适配器。
 *
 * 将风格列表按每页 9 个分组，每个 item 是一个 [StylePageView]。
 */
class StylePagerAdapter : RecyclerView.Adapter<StylePagerAdapter.StylePageHolder>() {

    private val styles = mutableListOf<ReplyStyle>()
    private var generatingStyleId: Int? = null
    private var onStyleClick: ((ReplyStyle) -> Unit)? = null

    /**
     * 更新整组风格数据。
     */
    fun submitStyles(newStyles: List<ReplyStyle>) {
        styles.clear()
        styles.addAll(newStyles)
        notifyDataSetChanged()
    }

    /**
     * 更新当前正在生成回复的风格 ID。
     */
    fun setGeneratingStyleId(styleId: Int?) {
        generatingStyleId = styleId
        notifyDataSetChanged()
    }

    /**
     * 设置风格点击回调。
     */
    fun setOnStyleClickListener(listener: (ReplyStyle) -> Unit) {
        onStyleClick = listener
    }

    override fun getItemCount(): Int {
        if (styles.isEmpty()) return 0
        return (styles.size + PAGE_SIZE - 1) / PAGE_SIZE
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StylePageHolder {
        val pageView = StylePageView(parent.context)
        pageView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT,
        )
        return StylePageHolder(pageView)
    }

    override fun onBindViewHolder(holder: StylePageHolder, position: Int) {
        val start = position * PAGE_SIZE
        val end = (start + PAGE_SIZE).coerceAtMost(styles.size)
        val pageStyles = styles.subList(start, end)
        val isBusy = generatingStyleId != null

        holder.pageView.bind(
            pageStyles = pageStyles,
            generatingStyleId = generatingStyleId,
            isBusy = isBusy,
            listener = { style ->
                onStyleClick?.invoke(style)
            },
        )
    }

    class StylePageHolder(
        val pageView: StylePageView,
    ) : RecyclerView.ViewHolder(pageView)

    companion object {
        /**
         * 每页展示的风格数量，3x3 网格即 9 个。
         */
        const val PAGE_SIZE = 9
    }
}
