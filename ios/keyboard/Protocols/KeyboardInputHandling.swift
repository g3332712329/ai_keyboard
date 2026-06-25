import Foundation

/// 这个协议把 ViewModel 和 UIKit 解耦。
///
/// ViewModel 不直接持有 textDocumentProxy，
/// 由 ViewController 实现这个协议，ViewModel 只调用这里面的方法，
/// 具体怎么插入、删除、清空由 ViewController 去处理。
protocol KeyboardInputHandling: AnyObject {
    /// 在当前光标位置插入文字。
    func insertText(_ text: String)

    /// 删除光标前的一个字符，相当于按一下退格。
    func deleteBackward()

    /// 清空当前输入框里的所有文字。
    ///
    /// 键盘扩展没有直接「全选删除」的 API，
    /// 实现里会先把光标移到末尾，再逐个 deleteBackward。
    func clearAllText()

    /// 切换下一个键盘，就是系统那个小地球。
    func showInputModeList()
}
