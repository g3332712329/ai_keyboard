import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // 注册 Pigeon 生成的 iOS 端通道实现。
    // 该通道用于向 Flutter 侧暴露 App Group 容器目录路径，
    // 使 MMKV 能够在容器 App 与键盘扩展之间共享数据。
    if let binaryMessenger = engineBridge.pluginRegistry.registrar(forPlugin: "GeneratedPluginRegistrant")?.messenger() {
      IosGroupAppEventChannelSetup.setUp(
        binaryMessenger: binaryMessenger,
        api: OnlyIosEventChannelImp()
      )
    }
  }
}
