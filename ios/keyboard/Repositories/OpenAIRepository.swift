import Foundation
import OpenAI

/// OpenAI 兼容平台的连接配置。
///
/// 只包含 Repository 真正需要的信息，避免把整个 KeyboardConfig 传进来。
struct AIPlatformConfig {
    let apiKey: String
    let baseURL: String?
    let model: String?
}

/// OpenAI 的调用单独放在这个 Repository 里。
///
/// 兼容 OpenAI 以及 OpenAI 格式的中转平台（DeepSeek、千问、Kimi 等）。
/// ViewModel 把用户上下文和风格传进来，这边组装成 ChatQuery，
/// 调完接口再把结果转回 AIReplyResponse 给 ViewModel。
final class OpenAIRepository {

    /// 网络请求超时时间，单位秒。
    static let requestTimeout: TimeInterval = 20.0

    let config: AIPlatformConfig
    private let openAI: OpenAI

    init(config: AIPlatformConfig) {
        self.config = config
        // 根据配置里的 baseURL 和 apiKey 初始化 OpenAI 客户端。
        // 如果 key 是空的，后面请求会失败，request 里会先判断一下。
        self.openAI = OpenAI(
            configuration: OpenAIRepository.makeOpenAIConfiguration(from: config)
        )
    }

    /// 请求 AI 生成回复。
    ///
    /// 这是一个异步方法，ViewModel 会在 Task 里调用。
    func requestReply(_ request: AIReplyRequest) async -> AIReplyResponse {
        guard !config.apiKey.isEmpty else {
            print("[OpenAIRepository] API Key 为空")
            return .failure(.missingConfig)
        }

        let messages = buildMessages(for: request)
        let model = config.model ?? "gpt-4o"
        let query = ChatQuery(
            messages: messages,
            model: model
        )

        print("[OpenAIRepository] 请求模型: \(model), baseURL: \(config.baseURL ?? "默认 OpenAI")")

        do {
            let result = try await openAI.chats(query: query)
            guard let content = result.choices.first?.message.content else {
                print("[OpenAIRepository] 返回内容为空")
                return .failure(.emptyResponse)
            }
            print("[OpenAIRepository] 请求成功")
            return .success(content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        } catch {
            // 完全访问没开时，网络请求会被系统直接拒绝，错误码是 NSURLErrorDataNotAllowed。
            // 其他 NSURLError 统一包成 networkError，避免把所有网络问题都归因到权限。
            let nsError = error as NSError
            print("[OpenAIRepository] 请求失败: \(nsError.domain) \(nsError.code) \(error.localizedDescription)")
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorDataNotAllowed {
                return .failure(.fullAccessDenied)
            }
            return .failure(.networkError(error))
        }
    }

    /// 把用户上下文和风格组装成 OpenAI 的消息列表。
    private func buildMessages(for request: AIReplyRequest) -> [ChatQuery.ChatCompletionMessageParam] {
        var messages: [ChatQuery.ChatCompletionMessageParam] = []

        // 1. 第一条 system message：优先用 Flutter 端统一写入的 AI 角色提示词模板填充，
        //    没有模板时才回退到风格 prompt 或兜底文案。
        let finalSystem: String
        if let template = request.aiRolePrompt, !template.isEmpty {
            finalSystem = String(
                format: template,
                request.styleName ?? "",
                request.stylePrompt ?? ""
            )
        } else if let stylePrompt = request.stylePrompt, !stylePrompt.isEmpty {
            finalSystem = stylePrompt
        } else if let styleName = request.styleName, !styleName.isEmpty {
            finalSystem = "你是一位得力的回复助手真实的人，你不是AI，请用\(styleName)风格回复用户的内容。"
        } else {
            finalSystem = request.systemPrompt ?? "你是一位得力的回复助手，请根据上下文生成合适的回复。"
        }
        messages.append(.system(.init(content: .textContent(finalSystem))))

        // 2. user message：当前输入框里的上下文。
        let userContent = request.context.isEmpty ? "请帮我生成一条回复" : request.context
        messages.append(.user(.init(content: .string(userContent))))

        return messages
    }

    /// 根据 AIPlatformConfig 里的 baseURL 和 apiKey 生成 OpenAI.Configuration。
    ///
    /// 直接把 baseURL 的 host 和 path 切出来用：
    /// - https://api.deepseek.com/v1 → host=api.deepseek.com, basePath=/v1
    /// - https://ark.cn-beijing.volces.com/api/v3 → host=ark.cn-beijing.volces.com, basePath=/api/v3
    ///
    /// 不再默认补 /v1，只有当 baseURL 没填或没路径时，才回退到 OpenAI 默认 /v1。
    private static func makeOpenAIConfiguration(from config: AIPlatformConfig) -> OpenAI.Configuration {
        let token = config.apiKey

        // 兜底：标准的 OpenAI 官方地址。
        var host = "api.openai.com"
        var basePath = "/v1"

        if let baseURLString = config.baseURL,
           let url = URL(string: baseURLString),
           let urlHost = url.host {
            host = urlHost

            // 用户配置了什么 path 就原样用，
            // 去掉末尾斜杠避免 OpenAI 客户端重复拼接。
            let path = url.path
            basePath = path.hasSuffix("/") ? String(path.dropLast()) : path
            if basePath.isEmpty {
                basePath = "/v1"
            }
        }

        return OpenAI.Configuration(
            token: token,
            host: host,
            basePath: basePath,
            timeoutInterval: requestTimeout
        )
    }
}
