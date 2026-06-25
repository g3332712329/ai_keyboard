package com.dboy.ai_keyboard.repository.openai

import com.aallam.openai.api.chat.ChatCompletionRequest
import com.aallam.openai.api.chat.ChatMessage
import com.aallam.openai.api.chat.ChatRole
import com.aallam.openai.api.http.Timeout
import com.aallam.openai.api.model.ModelId
import com.aallam.openai.client.OpenAI
import com.aallam.openai.client.OpenAIConfig
import com.aallam.openai.client.OpenAIHost
import com.dboy.ai_keyboard.config.AiPlatform
import com.dboy.ai_keyboard.config.DefaultConfig
import com.dboy.ai_keyboard.config.ReplyStyle
import com.dboy.ai_keyboard.utils.SharesLocalData
import kotlin.time.Duration.Companion.seconds

/**
 * 基于 openai-kotlin 的 AI 回复生成实现。
 *
 * 兼容 OpenAI 格式接口，支持自定义 baseUrl（如 DeepSeek、豆包等）。
 *
 * @param localData 本地存储实例，用于读取 Flutter 端写入的 AI 角色提示词模板。
 */
class OpenAiRepository(
    private val localData: SharesLocalData? = null,
) : AiRepository {

    override suspend fun generateReply(
        input: String,
        style: ReplyStyle,
        platform: AiPlatform,
    ): Result<String> = runCatching {
        if (platform.apiKey.isBlank()) {
            throw IllegalStateException("当前平台未配置 API Key")
        }
        if (platform.selectedModel.isBlank()) {
            throw IllegalStateException("当前平台未选择模型")
        }

        val openAI = createClient(platform)

        // 从本地存储读取 AI 角色提示词模板，用风格名称和风格描述填充占位符。
        val promptTemplate = localData?.getString(DefaultConfig.AI_ROLE_PROMPT_KEY)
            ?: DefaultConfig.DEFAULT_AI_ROLE_PROMPT
        val systemPrompt = String.format(
            promptTemplate.trimIndent(),
            style.name,
            style.prompt,
        )

        val request = ChatCompletionRequest(
            model = ModelId(platform.selectedModel),
            messages = listOf(
                ChatMessage(
                    role = ChatRole.System,
                    content = systemPrompt,
                ),
                ChatMessage(
                    role = ChatRole.User,
                    content = input,
                ),
            ),
        )

        val response = openAI.chatCompletion(request)
        val reply = response.choices.firstOrNull()?.message?.content?.trim().orEmpty()

        if (reply.isEmpty()) {
            throw IllegalStateException("AI 返回内容为空")
        }

        reply
    }

    /**
     * 根据平台配置创建 OpenAI 客户端。
     *
     * 处理 baseUrl 末尾可能带 /v1 的情况，避免重复拼接。
     */
    private fun createClient(platform: AiPlatform): OpenAI {
        val normalizedUrl = platform.baseUrl
            .trim()
            .removeSuffix("/")
            .removeSuffix("/v1")

        val config = OpenAIConfig(
            token = platform.apiKey,
            host = OpenAIHost(baseUrl = normalizedUrl),
            timeout = Timeout(
                request = 30.seconds,
                connect = 10.seconds,
                socket = 30.seconds,
            ),
        )
        return OpenAI(config)
    }
}
