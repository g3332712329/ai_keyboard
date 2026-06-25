package com.dboy.ai_keyboard.repository.openai

import com.dboy.ai_keyboard.config.AiPlatform
import com.dboy.ai_keyboard.config.ReplyStyle

/**
 * AI 回复生成仓库接口。
 */
interface AiRepository {

    /**
     * 根据输入内容和风格生成回复。
     *
     * @param input    用户粘贴的对话内容
     * @param style    选中的回复风格
     * @param platform 当前使用的 AI 平台配置
     * @return 生成的回复文本，失败时返回异常
     */
    suspend fun generateReply(
        input: String,
        style: ReplyStyle,
        platform: AiPlatform,
    ): Result<String>
}
