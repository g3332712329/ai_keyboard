import Foundation

/// 键盘配置模型，结构与 Flutter 端的 `ConfigurationInfo` 保持一致。
///
/// Flutter 端把整个配置对象序列化成 JSON 存到 MMKV，
/// 扩展这边直接按同样的结构解析，就能读到 API Key、模型、风格等。
struct KeyboardConfig: Codable {

    /// 配置数据版本号。
    var version: Int?

    /// AI 平台配置列表。
    var platforms: [AiPlatform]?

    /// 应用偏好设置。
    var preferences: [AppPreference]?

    /// 回复风格配置。
    var replyStyles: [ReplyStyle]?

    /// 当前启用的平台，找不到就返回 nil。
    var activePlatform: AiPlatform? {
        platforms?.first { $0.enable == true }
    }

    /// 当前启用平台的 API Key。
    var apiKey: String? {
        activePlatform?.apiKey
    }

    /// 当前启用平台的 base URL，比如 https://api.deepseek.com。
    var baseURL: String? {
        activePlatform?.baseUrl
    }

    /// 当前启用平台选中的模型。
    var model: String? {
        activePlatform?.selectedModel
    }

    /// 第一个内置风格的 prompt，作为 system prompt 用。
    /// 因为 Flutter 端当前没有把「当前选中的风格」持久化，扩展端只能先取第一个兜底。
    var systemPrompt: String? {
        replyStyles?.first { $0.isCustomization != true }?.prompt
    }

    /// 第一个内置风格的名称，作为风格提示用。
    var replyStyle: String? {
        replyStyles?.first { $0.isCustomization != true }?.name
    }

    /// 自动发送开关。
    ///
    /// 对应 Flutter 端 `appPreferenceKeyAutoSend`（值为 "auto_send"）的偏好设置。
    /// 开启后，AI 生成回复会自动插入宿主输入框并触发发送。
    var isAutoSendEnabled: Bool {
        preferences?.first { $0.key == "auto_send" }?.isOpen == true
    }

    /// AI 平台配置项。
    struct AiPlatform: Codable {
        var name: String?
        var baseUrl: String?
        var apiKey: String?
        var models: [String]?
        var selectedModel: String?
        var enable: Bool?
    }

    /// 应用偏好设置项。
    struct AppPreference: Codable {
        var key: String?
        var name: String?
        var desc: String?
        var isOpen: Bool?
    }

    /// 回复风格项。
    struct ReplyStyle: Codable {
        var id: Int?
        var name: String?
        var prompt: String?
        var isCustomization: Bool?
    }

    /// 从 JSON 字符串解析配置。
    ///
    /// 解析失败时返回 .failure，让上层决定是否提示用户，避免静默吞掉错误。
    static func fromJSON(_ jsonString: String?) -> Result<KeyboardConfig, Error> {
        guard let jsonString = jsonString,
              let data = jsonString.data(using: .utf8) else {
            return .failure(ConfigError.emptyData)
        }

        do {
            let config = try JSONDecoder().decode(KeyboardConfig.self, from: data)
            return .success(config)
        } catch {
            return .failure(error)
        }
    }

    /// 配置解析可能遇到的错误。
    enum ConfigError: Error, LocalizedError {
        case emptyData

        var errorDescription: String? {
            switch self {
            case .emptyData:
                return "配置数据为空"
            }
        }
    }

}
