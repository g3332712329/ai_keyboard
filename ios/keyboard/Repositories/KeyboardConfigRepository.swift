import Foundation
import MMKV

/// 在这层封装 MMKV 的读取逻辑。
///
/// 配置存在 App Group 的 MMKV 里，主 App 写，扩展读。
/// 这样用户改了 AI Key 或者风格，扩展每次启动都能拿到最新的。
final class KeyboardConfigRepository {

    /// 在 MMKV 里存配置用的 key，跟 Flutter 那边约定好的。
    private let configKey = "configuration"

    /// AI 角色提示词 key，跟 Flutter 端 AppConstants.dataKeyAiRolePrompt 保持一致。
    private let aiRolePromptKey = "ai_role_prompt"

    /// 共享的 MMKV 实例，外面初始化好了传进来。
    private let mmkv: MMKV?

    init(mmkv: MMKV?) {
        self.mmkv = mmkv
    }

    /// 读一次当前配置。
    ///
    /// MMKV 没值时返回默认空配置；有值但解析失败时返回 .failure。
    func loadConfig() -> Result<KeyboardConfig, Error> {
        guard let jsonString = mmkv?.string(forKey: configKey) else {
            print("[ConfigRepository] 还没读到配置，先用默认空配置")
            return .success(KeyboardConfig())
        }
        return KeyboardConfig.fromJSON(jsonString)
    }

    /// 读取 AI 角色提示词模板。
    ///
    /// 该模板由 Flutter 端首次启动时写入 MMKV，包含两个 `%s` 占位符：
    /// 第一个对应风格名称，第二个对应风格描述。
    /// 读不到时用本地兜底模板，避免首次安装主 App 没启动过时崩溃。
    func loadAiRolePrompt() -> String {
        let defaultPrompt = """
            你是一位得力的回复助手真实的人，请用 %s 风格回复用户的内容。
            回复内容控制在最少字数，真实的对话场景，必要时可以省略最后的标点符号，直接输出要恢复的内容，不包含任何markdown格式，不要解释。
            风格说明：%s
            """
        guard let prompt = mmkv?.string(forKey: aiRolePromptKey), !prompt.isEmpty else {
            print("[ConfigRepository] 还没读到 AI 角色提示词，先用默认模板")
            return defaultPrompt
        }
        return prompt
    }
}
