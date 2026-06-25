//
//  OnlyIosEventChannelImp.swift
//  Runner
//
//  Created by 杜江川 on 2026/6/13.
//

import Foundation
import UIKit

/// App Group 标识符。
///
/// 该标识符必须与 Apple Developer Portal、Xcode Signing & Capabilities 中
/// 为 Runner 和 keyboard 两个 Target 配置的 App Group 完全一致。
private let appGroupIdentifier = "group.com.dboy.ai.keyboard"

/// Pigeon 生成的 `IosGroupAppEventChannel` 协议实现。
///
/// 负责向 Flutter 侧暴露 iOS 原生能力：当前仅提供 App Group 容器目录路径查询。
/// 该路径用于初始化 MMKV 的 `groupDir`，使容器 App 与键盘扩展能够共享同一份 MMKV 数据。
class OnlyIosEventChannelImp: IosGroupAppEventChannel {

    /// 获取 App Group 共享容器的文件系统路径。
    ///
    /// - Returns: App Group 容器在沙盒中的绝对路径（例如 `/private/var/mobile/Containers/Shared/AppGroup/XXX`）。
    /// - Throws: 如果 App Group 未配置或无法获取容器 URL，则抛出 `PigeonError`，
    ///           Dart 侧会收到 `PlatformException`。
    func getAppGroupsDir() throws -> String {
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            throw PigeonError(
                code: "APP_GROUP_NOT_FOUND",
                message: "无法获取 App Group 容器路径，请检查 \(appGroupIdentifier) 是否在 Xcode / Apple Developer Portal 中正确配置。",
                details: nil
            )
        }

        // 必须返回文件系统路径（path），而不是 URL 字符串（absoluteString）。
        // MMKV 的 groupDir 参数需要的是一个普通目录路径。
        let path = url.path
        return path
    }
    
    /// 打开系统键盘设置页面。
    ///
    /// 实现策略：
    /// 1. 优先尝试私有 URL `App-Prefs:root=General&path=Keyboard`，
    ///    可直接定位到 设置 → 通用 → 键盘 → 键盘 列表。
    ///    ⚠️ 该 URL 属于未公开 API，理论上存在被 App Store 审核拒绝的风险，
    ///    但在实际键盘类应用中较常见。
    /// 2. 若私有 URL 不可用或系统拒绝打开，则回退到 `UIApplication.openSettingsURLString`，
    ///    打开本 App 的系统设置页，用户可点击「键盘」进入键盘设置。
    ///    这是 App Store 审核最安全的做法。
    ///
    /// - Returns: 是否成功触发打开操作（不代表用户已完成设置）。
    func openKeyboardSettings() throws -> Bool {
        let application = UIApplication.shared

        // 方案一：尝试直接跳转到系统键盘设置页。
        if let keyboardSettingsURL = URL(string: "App-Prefs:root=General&path=Keyboard"),
           application.canOpenURL(keyboardSettingsURL) {
            application.open(keyboardSettingsURL, options: [:], completionHandler: nil)
            return true
        }

        // 方案二：回退到本 App 的系统设置页。
        let appSettingsURLString = UIApplication.openSettingsURLString
        if let appSettingsURL = URL(string: appSettingsURLString),
           application.canOpenURL(appSettingsURL) {
            application.open(appSettingsURL, options: [:], completionHandler: nil)
            return true
        }

        return false
    }
    
    /// 检测本应用的键盘扩展是否已在系统设置中启用。
    ///
    /// 实现原理：
    /// 读取 `UserDefaults.standard` 中的 `AppleKeyboards` 列表，
    /// 该列表包含用户当前已启用的所有键盘 Bundle ID。
    /// 如果列表中包含本应用键盘扩展的 Bundle ID，则返回 true。
    ///
    /// ⚠️ 注意：
    /// - `AppleKeyboards` 是未公开的 UserDefaults key，理论上存在 App Store 审核风险，
    ///   但在键盘类应用中较为常见。
    /// - 模拟器上该列表可能不准确，建议以真机测试为准。
    /// - 该方法只能检测「是否已启用」，无法检测「是否已开启完全访问权限」。
    ///
    /// - Returns: 键盘扩展是否已启用。
    /// - Throws: 如果无法获取主 App Bundle ID，则抛出 `PigeonError`。
    func isKeyboardExtensionEnabled() throws -> Bool {
        guard let mainBundleId = Bundle.main.bundleIdentifier else {
            throw PigeonError(
                code: "BUNDLE_ID_NOT_FOUND",
                message: "无法获取主 App 的 Bundle Identifier",
                details: nil
            )
        }

        // 键盘扩展的 Bundle ID 约定为主 App Bundle ID + ".keyboard"，
        // 与 Xcode 中 keyboard target 的 PRODUCT_BUNDLE_IDENTIFIER 保持一致。
        let keyboardBundleId = mainBundleId + ".keyboard"

        guard let enabledKeyboards = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else {
            return false
        }

        return enabledKeyboards.contains(keyboardBundleId)
    }
    
    
}
