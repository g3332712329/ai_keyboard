import SwiftUI
import UIKit

/// SwiftUI 键盘界面，完全参照 Flutter 端 `keyboard_view.dart` 的固定竖屏布局。
///
/// 这个 View 只负责把 ViewModel 里的状态画出来，
/// 用户点按钮之后调用 ViewModel 的方法，具体逻辑交给 ViewModel。
///
/// 布局结构：
/// - 顶部只读输入框
/// - 下方左右分栏：
///   - 左侧（flex: 3）：粘贴按钮 + 风格分页网格
///   - 右侧（宽度 64）：删除 / 清空 / 发送
///
/// 不做横竖屏布局切换，始终保持这一套排布。
struct KeyboardView: View {

    /// ViewModel 由外面创建并传进来，这个 View 只观察它的状态变化。
    @ObservedObject var viewModel: KeyboardViewModel

    /// 当前风格分页的索引，给页面指示器用。
    @State private var currentPage: Int = 0

    var body: some View {
        ZStack {
            // 背景色，对应 Flutter 的 surfaceContainerHighest。
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                inputArea
                    .frame(height: 40)

                HStack(spacing: 8) {
                    leftFunctionalArea

                    rightActionColumn
                        .frame(width: 64)
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            // 底部留出足够空间，避免贴到 Home 指示条。
            .padding(.bottom, 12)

            // 错误提示浮层，有错误时显示在顶部。
            errorToast
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 4)
        }
    }

    // MARK: - 顶部输入框

    /// 只读输入框，展示当前 inputText。
    ///
    /// 用户通过「粘贴内容」按钮往里面填内容，
    /// 不能直接编辑，避免键盘里再弹出键盘。
    private var inputArea: some View {
        HStack {
            if viewModel.inputText.isEmpty {
                Text("粘贴对话内容以生成回复...")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.tertiaryLabel))
            } else {
                Text(viewModel.inputText)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Color(.systemBackground),
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
    }

    // MARK: - 左侧功能区

    /// 左侧功能区：粘贴按钮 + 风格分页网格。
    private var leftFunctionalArea: some View {
        VStack(spacing: 8) {
            pasteButton
                .frame(height: 40)

            stylePager
                .frame(maxHeight: .infinity)
        }
    }

    /// 「粘贴内容」按钮。
    ///
    /// 点击后从系统剪贴板读取文本，更新到 ViewModel 的 inputText。
    private var pasteButton: some View {
        Button(action: {
            viewModel.pasteContent()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "doc.on.clipboard")
                    .font(.system(size: 18))
                Text("粘贴内容")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.systemBackground),
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }

    /// 风格分页网格。
    ///
    /// 每页最多 9 个风格，排成 3×3。
    /// 风格数量超过 9 个时，底部显示页面指示器，可以左右滑动翻页。
    private var stylePager: some View {
        VStack(spacing: 6) {
            TabView(selection: $currentPage) {
                ForEach(0..<pageCount, id: \.self) { pageIndex in
                    StylePageView(
                        styles: pageStyles(for: pageIndex),
                        generatingStyleId: viewModel.generatingStyleId,
                        onStyleTap: { style in
                            viewModel.generateByStyle(style)
                        }
                    )
                    .tag(pageIndex)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            if pageCount > 1 {
                PageIndicator(
                    pageCount: pageCount,
                    currentPage: currentPage,
                    color: Color(.systemGray)
                )
                .frame(height: 6)
            }
        }
    }

    /// 总页数。
    private var pageCount: Int {
        max(1, Int(ceil(Double(viewModel.styles.count) / 9.0)))
    }

    /// 取出某一页的 9 个风格。
    private func pageStyles(for pageIndex: Int) -> [KeyboardConfig.ReplyStyle] {
        let start = pageIndex * 9
        let end = min(start + 9, viewModel.styles.count)
        guard start < viewModel.styles.count else { return [] }
        return Array(viewModel.styles[start..<end])
    }

    // MARK: - 右侧操作列

    /// 右侧固定宽度的操作列：删除、清空、发送。
    private var rightActionColumn: some View {
        VStack(spacing: 8) {
            IconActionButton(
                icon: "delete.backward",
                label: "删除",
                action: {
                    viewModel.deleteBackward()
                }
            )
            .frame(height: 40)

            IconActionButton(
                icon: "xmark.bin",
                label: "清空",
                action: {
                    viewModel.clearHostInput()
                }
            )
            .frame(height: 40)

            Button(action: {
                viewModel.submitHostInput()
            }) {
                Text("发送")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Color.accentColor,
                        in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
            }
            .buttonStyle(.plain)
            .frame(maxHeight: .infinity)
            .disabled(viewModel.generatingStyleId != nil)
            .opacity(viewModel.generatingStyleId != nil ? 0.6 : 1.0)
        }
    }

    // MARK: - 错误提示

    /// 一个简单的顶部 Toast，展示 ViewModel 里的 errorMessage。
    ///
    /// 出现 2 秒后自动消失，并把 errorMessage 置空。
    private var errorToast: some View {
        VStack {
            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Color(.systemRed),
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                viewModel.errorMessage = nil
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - 单页风格网格

/// 一页 3×3 的风格网格。
///
/// 每行和每列都用 flexible 空间均分，避免固定尺寸导致溢出。
/// 空位用透明占位填充，保证按钮不会占满整行。
private struct StylePageView: View {
    let styles: [KeyboardConfig.ReplyStyle]
    let generatingStyleId: Int?
    let onStyleTap: (KeyboardConfig.ReplyStyle) -> Void

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { column in
                        let index = row * 3 + column
                        if index < styles.count {
                            let style = styles[index]
                            StyleChip(
                                style: style,
                                isGenerating: style.id == generatingStyleId,
                                isBusy: generatingStyleId != nil && style.id != generatingStyleId,
                                onTap: { onStyleTap(style) }
                            )
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 风格标签按钮

/// 单个风格按钮。
///
/// 正常状态显示风格名称；
/// 正在生成时显示一个转圈指示器；
/// 其他风格在生成时会被禁用，避免并发请求。
private struct StyleChip: View {
    let style: KeyboardConfig.ReplyStyle
    let isGenerating: Bool
    let isBusy: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isGenerating ? Color.accentColor : Color(.systemBackground))

                if isGenerating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.7)
                } else {
                    Text(style.name ?? "")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(isGenerating ? .white : .primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 4)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isBusy || isGenerating)
        .opacity(isBusy ? 0.6 : 1.0)
        .accessibilityLabel("\(style.name ?? ""), 生成回复")
        .accessibilityHint("点击用该风格生成一条回复")
    }
}

// MARK: - 右侧图标操作按钮

/// 图标操作按钮，用于删除、清空等操作。
private struct IconActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color(.systemBackground),
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

// MARK: - 页面指示器

/// 风格分页的圆点指示器。
private struct PageIndicator: View {
    let pageCount: Int
    let currentPage: Int
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? color : color.opacity(0.4))
                    .frame(width: index == currentPage ? 12 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}
