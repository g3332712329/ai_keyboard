import Foundation

/// 发给 AI 的请求参数封装。
///
/// 里面包含当前输入框里的上下文、用户选的风格，
/// 交给 Repository 的时候比较干净，不会传一堆零散参数。
struct AIReplyRequest {
    /// 输入框里已经有的内容，比如对方发的消息。
    let context: String

    /// 风格的完整 prompt，优先用它作为 system message。
    let stylePrompt: String?

    /// 风格的名称，当没有 prompt 时用来生成兜底 system message。
    let styleName: String?

    /// 补充的系统提示词，优先级低于用户配置的 stylePrompt。
    let systemPrompt: String?

    /// AI 角色提示词模板，包含 `%s` 占位符。
    ///
    /// 由 Flutter 端写入本地存储，iOS 扩展读取后填充风格名称和风格描述。
    let aiRolePrompt: String?

    init(
        context: String,
        stylePrompt: String? = nil,
        styleName: String? = nil,
        systemPrompt: String? = nil,
        aiRolePrompt: String? = nil
    ) {
        self.context = context
        self.stylePrompt = stylePrompt
        self.styleName = styleName
        self.systemPrompt = systemPrompt
        self.aiRolePrompt = aiRolePrompt
    }
}
