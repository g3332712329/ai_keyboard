import UIKit
import SwiftUI
import MMKV

/// 键盘扩展的入口控制器，只做初始化和桥接。
///
/// 职责：
/// 1. 启动时初始化 MMKV，方便跟主 App 共享配置。
/// 2. 创建一个 KeyboardViewModel，把 MMKV 传给它。
/// 3. 把 SwiftUI 的 KeyboardView 用 UIHostingController 包起来，贴到键盘区域。
/// 4. 实现 KeyboardInputHandling 协议，让 ViewModel 能间接操作输入框。
///
/// 业务逻辑和 UI 都不在这里，只做协调和桥接。
class KeyboardViewController: UIInputViewController {

    // MARK: - 依赖

    /// 跟主 App 共享的 MMKV 实例。
    private var sharedMMKV: MMKV?

    /// App Group 标识符，必须跟主 App 保持一致。
    private let appGroupIdentifier = "group.com.dboy.ai.keyboard"

    /// 防止 MMKV 被重复初始化。
    ///
    /// UIInputViewController 的 view 可能被系统重建，
    /// 用这个静态标志保证全局只初始化一次 MMKV。
    private static var hasInitializedMMKV = false

    /// ViewModel 负责所有业务逻辑。
    private lazy var viewModel: KeyboardViewModel = {
        KeyboardViewModel(mmkv: sharedMMKV)
    }()

    // MARK: - 生命周期

    override func viewDidLoad() {
        super.viewDidLoad()

        // 先初始化 MMKV，后面 ViewModel 要用。
        setupSharedMMKV()

        // 把自身作为 inputHandler 给 ViewModel，这样它就能操作输入框了。
        viewModel.inputHandler = self

        // 搭 SwiftUI 界面。
        setupSwiftUIKeyboardView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次键盘要出来的时候，重新读一下配置。
        viewModel.refreshConfig()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // 系统告知现在需不需要显示地球键，同步给 ViewModel。
        viewModel.needsInputModeSwitchKey = self.needsInputModeSwitchKey
    }

    // MARK: - UI 搭建

    /// 把 SwiftUI 的 KeyboardView 挂到当前 view 上。
    private func setupSwiftUIKeyboardView() {
        let keyboardView = KeyboardView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: keyboardView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // 固定高度 280pt，不再根据横竖屏切换布局或高度。
        view.heightAnchor.constraint(equalToConstant: 280).isActive = true
    }

    // MARK: - MMKV 初始化

    /// 初始化共享 MMKV。
    ///
    /// 必须把 groupDir 指向 App Group 容器，这样主 App 写进去的配置扩展才能读到。
    /// 用静态标志防止 view 重建时重复初始化。
    private func setupSharedMMKV() {
        guard !Self.hasInitializedMMKV else {
            // 已经初始化过，直接打开同一个 mmapID 即可。
            sharedMMKV = MMKV(mmapID: "ai_keyboard_config", mode: .multiProcess)
            return
        }

        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            print("[KeyboardVC] 拿不到 App Group 路径，检查一下 identifier 对不对")
            return
        }

        let groupDir = groupURL.path
        MMKV.initialize(rootDir: nil, groupDir: groupDir, logLevel: .info)
        Self.hasInitializedMMKV = true

        // 跟 Flutter 端用同一个 mmapID 和模式。
        sharedMMKV = MMKV(mmapID: "ai_keyboard_config", mode: .multiProcess)
    }
}

// MARK: - KeyboardInputHandling

extension KeyboardViewController: KeyboardInputHandling {

    /// 插入文字，直接调用 textDocumentProxy。
    func insertText(_ text: String) {
        textDocumentProxy.insertText(text)
    }

    /// 删除光标前一个字符。
    func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }

    /// 清空当前输入框里的所有文字。
    ///
    /// 键盘扩展没有「全选删除」的 API，只能反复 deleteBackward。
    /// 这里给循环加了最大次数，避免某些宿主 App 上下文异常时死循环。
    func clearAllText() {
        let maxAttempts = 5000
        var attempts = 0

        // 如果当前有选中内容，先删一次选中内容。
        if let selected = textDocumentProxy.selectedText, !selected.isEmpty {
            textDocumentProxy.deleteBackward()
        }

        // 删光标前面的文字。
        while let before = textDocumentProxy.documentContextBeforeInput,
              !before.isEmpty,
              attempts < maxAttempts {
            textDocumentProxy.deleteBackward()
            attempts += 1
        }

        // 此时光标在文本开头，后面可能还有内容，把光标移到末尾再删。
        if let after = textDocumentProxy.documentContextAfterInput, !after.isEmpty {
            textDocumentProxy.adjustTextPosition(byCharacterOffset: after.count)
            for _ in 0..<min(after.count, maxAttempts - attempts) {
                textDocumentProxy.deleteBackward()
                attempts += 1
            }
        }

        if attempts >= maxAttempts {
            print("[KeyboardVC] clearAllText 达到最大尝试次数，可能没删干净")
        }
    }

    /// 弹出系统键盘切换列表。
    func showInputModeList() {
        // 这个方法是 UIInputViewController 自带的，直接调用自身即可。
        advanceToNextInputMode()
    }
}
