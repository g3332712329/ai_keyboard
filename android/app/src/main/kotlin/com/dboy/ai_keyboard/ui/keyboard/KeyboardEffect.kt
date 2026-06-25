package com.dboy.ai_keyboard.ui.keyboard

/**
 * 键盘页面的一次性副作用。
 *
 * 与 [KeyboardState] 不同，Effect 不会被持久化到 UI 状态里，
 * 只消费一次，例如 Toast、插入文本、切换输入法等。
 */
sealed class KeyboardEffect {

    /**
     * 将生成的回复文本提交到宿主输入框。
     *
     * @param text     要提交的文本
     * @param autoSend 是否自动触发发送
     */
    data class CommitText(
        val text: String,
        val autoSend: Boolean = false,
    ) : KeyboardEffect()

    /**
     * 显示一个临时提示。
     *
     * @param message 提示文案
     */
    data class ShowToast(
        val message: String,
    ) : KeyboardEffect()

    /**
     * 切换到下一个输入法。
     */
    data object SwitchIme : KeyboardEffect()
}
