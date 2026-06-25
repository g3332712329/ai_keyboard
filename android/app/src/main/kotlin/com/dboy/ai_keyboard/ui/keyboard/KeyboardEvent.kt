package com.dboy.ai_keyboard.ui.keyboard

import com.dboy.ai_keyboard.config.ReplyStyle

/**
 * 键盘页面上的用户意图。
 *
 * View 层把所有用户操作和生命周期事件都转换成 [KeyboardEvent]，
 * 交给 [KeyboardViewModel] 处理。
 */
sealed class KeyboardEvent {

    /**
     * 键盘弹出时触发，用于重新加载配置和风格数据。
     */
    data object LoadConfig : KeyboardEvent()

    /**
     * 点击「粘贴内容」按钮，把读取到的剪贴板文本交给 ViewModel。
     *
     * @param text 剪贴板内容
     */
    data class PasteContent(
        val text: String,
    ) : KeyboardEvent()

    /**
     * 点击某个回复风格，开始生成 AI 回复。
     *
     * @param style 被选中的风格
     */
    data class GenerateReply(
        val style: ReplyStyle,
    ) : KeyboardEvent()

    /**
     * 清空已显示的错误信息。
     */
    data object ClearError : KeyboardEvent()
}
