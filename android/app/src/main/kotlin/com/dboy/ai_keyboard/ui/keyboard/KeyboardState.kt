package com.dboy.ai_keyboard.ui.keyboard

import com.dboy.ai_keyboard.config.AiPlatform
import com.dboy.ai_keyboard.config.ReplyStyle

/**
 * 键盘 UI 单一状态。
 *
 * MVI 中所有 UI 变化都通过更新这个状态对象来驱动，
 * View 层只负责观察状态并刷新界面。
 */
data class KeyboardState(
    /**
     * 顶部输入框展示的文本，也就是用户已经粘贴的对话内容。
     */
    val inputText: String = "",

    /**
     * 当前可用的回复风格列表。
     */
    val styles: List<ReplyStyle> = emptyList(),

    /**
     * 当前选中的 AI 平台，生成回复时使用。
     */
    val selectedPlatform: AiPlatform? = null,

    /**
     * 是否开启自动发送偏好。
     */
    val autoSend: Boolean = false,

    /**
     * 当前正在生成回复的风格 ID。
     *
     * 为 null 表示没有正在生成的请求。
     */
    val generatingStyleId: Int? = null,

    /**
     * 是否正在加载配置或初始化数据。
     */
    val isLoading: Boolean = false,

    /**
     * 错误提示信息，显示后应由 View 层通知 ViewModel 清空。
     */
    val errorMessage: String? = null,
)
