import Foundation

/// 统一的结果枚举。
///
/// 现在底层是 OpenAI，后面如果换成 Claude、Gemini 之类的，
/// ViewModel 不用关心，只要拿到 success 或 failure 就行。
enum AIReplyResponse {
    /// 成功，直接返回生成的文字。
    case success(String)

    /// 失败，附带一个原因，方便显示提示或者打日志。
    case failure(AIReplyError)
}

/// 把可能遇到的错误简单归归类。
enum AIReplyError: Error {
    /// 没有 API Key，或者配置不完整。
    case missingConfig

    /// 网络请求本身出错了。
    case networkError(Error)

    /// AI 接口返回了空内容或者没法解析。
    case emptyResponse

    /// 完全访问权限没开，网络被系统拦了。
    case fullAccessDenied

    var message: String {
        switch self {
        case .missingConfig:
            return "还没配置好 API Key"
        case .networkError(let error):
            return "网络请求出错：\(error.localizedDescription)"
        case .emptyResponse:
            return "AI 没返回内容"
        case .fullAccessDenied:
            return "请先开启「允许完全访问」权限"
        }
    }
}
