import Foundation
import Combine
import MMKV
import UIKit

/// 这个 ViewModel 承载键盘的核心状态和逻辑。
///
/// View 只关心显示什么、用户点了什么，
/// 具体怎么读配置、怎么调 AI、怎么操作宿主输入框，都在这边协调。
///
/// 用 @Published 暴露状态，SwiftUI 的 View 会自动刷新。
///
/// 标记为 @MainActor 是因为所有状态最终都要回到主线程更新，
/// 这样 Task 里不用再包一层 MainActor.run，Swift 6 的并发检查也更干净。
@MainActor
final class KeyboardViewModel: ObservableObject {

    // MARK: - 常量

    /// 粘贴内容和请求上下文的最大字符数。
    ///
    /// 超过这个长度会截断，避免 Token 爆炸和请求过慢。
    static let maxContextLength = 3000

    // MARK: - 给 View 看的状态

    /// 当前输入框里的上下文，对应 Flutter 端的 inputText。
    /// 用户通过「粘贴内容」按钮把剪贴板里的对话贴到这里。
    @Published var inputText: String = ""

    /// 从配置里加载出来的回复风格列表。
    @Published var styles: [KeyboardConfig.ReplyStyle] = []

    /// 当前正在生成回复的风格 ID，View 会显示 loading。
    /// nil 表示没有风格在生成中。
    @Published var generatingStyleId: Int?

    /// 错误提示，有内容的时候 View 可以弹个提示。
    @Published var errorMessage: String? = nil

    /// 要不要显示切换键盘的地球按钮，ViewController 同步过来之后更新。
    @Published var needsInputModeSwitchKey: Bool = false

    // MARK: - 依赖

    /// 通过这个角色来操作宿主输入框，不直接碰 UIKit。
    weak var inputHandler: KeyboardInputHandling?

    /// 读配置的家伙。
    private let configRepository: KeyboardConfigRepository

    /// 当前内存里的配置。
    private var config: KeyboardConfig

    /// 当前 AI 角色提示词模板，从本地存储读取。
    private var aiRolePrompt: String = ""

    /// OpenAI 请求客户端。
    ///
    /// 配置变化时才重建，避免每次请求都新建一个。
    private var openAIRepository: OpenAIRepository?

    /// 取消任务用的，避免页面还在请求的时候 ViewModel 已经被释放。
    private var currentTask: Task<Void, Never>?

    // MARK: - 初始化

    init(mmkv: MMKV?) {
        self.configRepository = KeyboardConfigRepository(mmkv: mmkv)
        self.config = KeyboardConfig()

        switch configRepository.loadConfig() {
        case .success(let loadedConfig):
            self.config = loadedConfig
        case .failure(let error):
            print("[KeyboardVM] 配置加载失败: \(error.localizedDescription)")
            self.errorMessage = "配置读取失败，请重新保存设置"
        }

        self.aiRolePrompt = configRepository.loadAiRolePrompt()

        rebuildOpenAIRepositoryIfNeeded()
        loadStyles()
    }

    /// 每次键盘显示或者被切回来的时候，重新读一下配置。
    ///
    /// 因为键盘扩展没有一直活着，主 App 改配置的时候扩展可能已经被杀了，
    /// 所以每次出现时刷新一下最保险。
    func refreshConfig() {
        switch configRepository.loadConfig() {
        case .success(let loadedConfig):
            config = loadedConfig
            aiRolePrompt = configRepository.loadAiRolePrompt()
            rebuildOpenAIRepositoryIfNeeded()
            loadStyles()
        case .failure(let error):
            print("[KeyboardVM] 配置刷新失败: \(error.localizedDescription)")
            errorMessage = "配置读取失败，请重新保存设置"
        }
    }

    // MARK: - 输入操作

    /// 往宿主输入框里插入文字。
    func insertText(_ text: String) {
        inputHandler?.insertText(text)
    }

    /// 用户按了退格键。
    func deleteBackward() {
        inputHandler?.deleteBackward()
    }

    /// 清空宿主输入框里的所有文字。
    ///
    /// 对应 Flutter 端「清空」按钮的行为：清空聊天输入框。
    func clearHostInput() {
        print("[KeyboardVM] 清空宿主输入框")
        inputHandler?.clearAllText()
    }

    /// 用户按了小地球，通知 ViewController 弹出键盘切换列表。
    func showNextKeyboard() {
        inputHandler?.showInputModeList()
    }

    /// 从剪贴板粘贴内容到 inputText。
    ///
    /// 键盘扩展的完全访问权限开启后，才能读到系统剪贴板。
    /// 超过最大长度时会截断并提示用户。
    func pasteContent() {
        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            print("[KeyboardVM] 剪贴板为空")
            errorMessage = "剪贴板为空"
            return
        }

        let trimmedText = text.truncated(to: Self.maxContextLength)
        if text.count > Self.maxContextLength {
            print("[KeyboardVM] 剪贴板内容过长，已截断至 \(Self.maxContextLength) 字符")
            errorMessage = "内容过长，已自动截断"
        }

        print("[KeyboardVM] 从剪贴板粘贴内容，长度: \(trimmedText.count)")
        inputText = trimmedText
    }

    /// 清空键盘里显示的粘贴内容。
    ///
    /// 如果用户想重新粘贴一段新对话，可以调这个。
    func clearPastedContent() {
        print("[KeyboardVM] 清空粘贴内容")
        inputText = ""
    }

    /// 触发宿主输入框的提交/完成事件。
    ///
    /// 键盘扩展没有直接触发 Return 的 API，这里向宿主输入框插入一个换行符，
    /// 大多数聊天类 App（微信、短信等）会把它当成发送/提交处理。
    ///
    /// 对应 Flutter 端「发送」按钮的行为。
    func submitHostInput() {
        print("[KeyboardVM] 触发宿主输入框提交")
        insertText("\n")
    }

    // MARK: - 风格列表

    /// 从当前配置里加载回复风格列表。
    ///
    /// 初始化、每次键盘出现、配置刷新后都会调用。
    private func loadStyles() {
        styles = config.replyStyles ?? []
        print("[KeyboardVM] 加载到 \(styles.count) 个风格")
    }

    // MARK: - AI 回复

    /// 根据当前 inputText 和选中的风格生成一条回复。
    ///
    /// 先校验 inputText 和 API Key，再交给 OpenAIRepository 去请求。
    /// 请求过程中 generatingStyleId 被设置，View 可以显示 loading。
    /// 生成成功后，直接把回复插入到宿主输入框，跟 Flutter 端 onGenerated 的行为一致。
    func generateByStyle(_ style: KeyboardConfig.ReplyStyle) {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("[KeyboardVM] 生成失败：inputText 为空")
            errorMessage = "请先粘贴对话内容"
            return
        }

        guard let repository = openAIRepository else {
            print("[KeyboardVM] 生成失败：OpenAIRepository 未初始化")
            errorMessage = "还没配置好 API Key"
            return
        }

        let context = inputText.truncated(to: Self.maxContextLength)
        if inputText.count > Self.maxContextLength {
            print("[KeyboardVM] 输入内容过长，已截断至 \(Self.maxContextLength) 字符")
            errorMessage = "输入内容过长，已自动截断后生成"
        }

        print("[KeyboardVM] 开始用风格「\(style.name ?? "")」生成回复")

        // 取消上一次的请求，避免用户连点导致多个请求并发。
        currentTask?.cancel()
        currentTask = nil

        let request = AIReplyRequest(
            context: context,
            stylePrompt: style.prompt,
            styleName: style.name,
            systemPrompt: config.systemPrompt,
            aiRolePrompt: aiRolePrompt
        )

        generatingStyleId = style.id
        errorMessage = nil

        currentTask = Task { [weak self] in
            let response = await repository.requestReply(request)

            // 因为整个 ViewModel 是 @MainActor，Task 会自动回到主线程，
            // 但 self 是弱引用，先把它绑定成强引用再操作属性。
            guard let self = self else { return }

            self.generatingStyleId = nil
            self.currentTask = nil
            switch response {
            case .success(let reply):
                print("[KeyboardVM] 生成成功，回复长度: \(reply.count)")
                self.insertText(reply)

                // 如果用户开启了「自动发送」，生成后立刻触发宿主输入框的提交。
                // 这里先等一帧，让宿主 App 有机会处理刚刚插入的文字，
                // 再插入换行符模拟 Return/发送，兼容性更好。
                if self.config.isAutoSendEnabled {
                    print("[KeyboardVM] 自动发送已开启，触发提交")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.submitHostInput()
                    }
                }
            case .failure(let error):
                print("[KeyboardVM] 生成失败: \(error.message)")
                self.errorMessage = error.message
            }
        }
    }

    // MARK: - 内部工具

    /// 根据当前配置重建 OpenAIRepository。
    ///
    /// 只有 API Key、baseURL、model 任意一项发生变化时才重建，
    /// 避免每次生成请求都创建新客户端。
    private func rebuildOpenAIRepositoryIfNeeded() {
        guard let apiKey = config.apiKey, !apiKey.isEmpty else {
            openAIRepository = nil
            return
        }

        let newPlatformConfig = AIPlatformConfig(
            apiKey: apiKey,
            baseURL: config.baseURL,
            model: config.model
        )

        if let existing = openAIRepository {
            // 简单判断：如果关键参数没变，就不重建。
            // 这里直接比较 config 内容；如果 OpenAI 客户端本身有状态，可以进一步优化。
            let shouldRebuild = existing.config.apiKey != newPlatformConfig.apiKey
                || existing.config.baseURL != newPlatformConfig.baseURL
                || existing.config.model != newPlatformConfig.model
            if !shouldRebuild { return }
        }

        openAIRepository = OpenAIRepository(config: newPlatformConfig)
        print("[KeyboardVM] 已重建 OpenAIRepository")
    }
}

// MARK: - 小工具

private extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

private extension String {
    /// 把字符串截断到指定最大长度。
    func truncated(to maxLength: Int) -> String {
        guard count > maxLength else { return self }
        return String(prefix(maxLength))
    }
}
