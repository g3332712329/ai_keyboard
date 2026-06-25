import 'dart:async';
import 'dart:io';

import 'package:ai_keyboard/channel/only_ios_event_channel.g.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

/// 活动回调
/// 返回String类型，如果返回值不为null 会弹出对应的toast消息。
typedef ActionCallBack = FutureOr<String?> Function();

/// 引导步骤的数据模型。
///
/// 将「步骤内容」与「步骤渲染」解耦，方便根据不同平台、不同系统版本
/// 动态调整显示的步骤。
class SetupStep {
  const SetupStep({
    required this.tag,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.instruction,
    this.actionTitle,
    this.action,
  });

  /// 步骤标签，例如「第一步」。
  final String tag;

  /// 步骤图标。
  final IconData icon;

  /// 步骤标题。
  final String title;

  /// 步骤副标题。
  final String subtitle;

  /// 具体设置路径说明。
  final String instruction;

  /// 操作按钮文案。
  final String? actionTitle;

  /// 操作按钮回调，为空时不显示按钮
  final ActionCallBack? action;
}

/// 当前系统环境信息。
///
/// 由 [SetupStepManager] 统一收集并分发给所有已注册的 [SetupStepProvider]，
/// 供各提供器的 [SetupStepProvider.shouldProvide] 决策使用。
class SetupSystemInfo {
  const SetupSystemInfo({
    required this.platform,
    this.osVersion,
    this.manufacturer,
    this.model,
  });

  /// 操作系统平台。
  final TargetPlatform platform;

  /// 操作系统版本号，例如 "17.5"、"14.2"。
  final String? osVersion;

  /// 设备制造商，例如 "Xiaomi"、"vivo"、"Apple"。
  ///
  /// Android 端对应 [AndroidDeviceInfo.manufacturer]，
  /// iOS 端通常固定为 "Apple" 或留空。
  final String? manufacturer;

  /// 设备型号，例如 "iPhone15,2"、"2304FPN6DC"。
  final String? model;

  /// 基于 [Platform] 的同步构造（兜底方案）。
  factory SetupSystemInfo.fromPlatform() {
    return SetupSystemInfo(platform: _platformFromDartIO());
  }

  /// 通过 [DeviceInfoPlugin] 异步获取真实系统信息。
  static Future<SetupSystemInfo> fromDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return SetupSystemInfo(
        platform: TargetPlatform.iOS,
        osVersion: iosInfo.systemVersion,
        manufacturer: 'Apple',
        model: iosInfo.utsname.machine,
      );
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return SetupSystemInfo(
        platform: TargetPlatform.android,
        osVersion: androidInfo.version.release,
        manufacturer: androidInfo.manufacturer,
        model: androidInfo.model,
      );
    }
    return SetupSystemInfo(platform: TargetPlatform.android);
  }

  static TargetPlatform _platformFromDartIO() {
    if (Platform.isIOS) return TargetPlatform.iOS;
    if (Platform.isAndroid) return TargetPlatform.android;
    return TargetPlatform.android;
  }

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isAndroid => platform == TargetPlatform.android;

  /// 解析 [osVersion] 的主版本号，解析失败返回 null。
  ///
  /// 例如 "17.5.1" → 17，"14" → 14。
  int? get osVersionMajor {
    final version = osVersion;
    if (version == null || version.isEmpty) return null;
    return int.tryParse(version.split('.').first);
  }
}

/// 步骤提供器接口。
///
/// 每一种平台/版本/厂商的引导流程都可以封装为一个提供器。
/// 新增适配时，只需实现本接口并注册到 [SetupStepManager]，无需改动 UI。
///
/// 设计模式上对应 **Strategy Pattern（策略模式）**：每个提供器是一种「生成步骤列表的策略」；
/// 多个提供器由 [SetupStepManager] 统一注册、调度，又构成 **Registry Pattern（注册表模式）**。
abstract class SetupStepProvider {
  /// 根据 [info] 判断当前提供器是否适用。
  ///
  /// 例如仅当平台为 iOS 且版本 >= 17 时返回 true。
  bool shouldProvide(SetupSystemInfo info);

  /// 返回当前提供器对应的步骤列表。
  ///
  /// 只有在 [shouldProvide] 返回 true 时，管理器才会调用此方法。
  List<SetupStep> provide(SetupSystemInfo info);
}

/// iOS 默认引导步骤提供器。
class IOSDefaultSetupStepProvider implements SetupStepProvider {
  const IOSDefaultSetupStepProvider();

  @override
  bool shouldProvide(SetupSystemInfo info) => info.isIOS;

  @override
  List<SetupStep> provide(SetupSystemInfo info) {
    final iosGroupAppEventChannel = IosGroupAppEventChannel();
    return [
      SetupStep(
        tag: '第一步',
        icon: Icons.phone_iphone,
        title: '启用键盘',
        subtitle: '打开 iOS 设置应用，找到键盘选项',
        instruction: '设置 → 通用 → 键盘 → 键盘 → 添加新键盘',
        actionTitle: '去设置',
        action: () async {
          await iosGroupAppEventChannel.openKeyboardSettings();
          return null;
        },
      ),
      SetupStep(
        tag: '第二步',
        icon: Icons.lock_open_outlined,
        title: '开启「完全访问」',
        subtitle: '允许键盘使用网络与扩展功能',
        instruction: '设置 → 通用 → 键盘 → 键盘 → AI 回复助手 → 允许完全访问',
        actionTitle: '检测是否已开启',
      ),
      SetupStep(
        tag: '第三步',
        icon: Icons.keyboard_alt_outlined,
        title: '开启「AI 回复助手」',
        subtitle: '在键盘列表中找到并打开开关',
        instruction: '键盘列表 → AI 回复助手 → 开启',
        actionTitle: '检测是否已启用',
        action: () async {
          var keyboardExtensionEnabled = await iosGroupAppEventChannel
              .isKeyboardExtensionEnabled();
          if (keyboardExtensionEnabled) {
            return "开启成功";
          } else {
            return "开启失败";
          }
        },
      ),
    ];
  }
}

/// Android 默认引导步骤提供器。
class AndroidDefaultSetupStepProvider implements SetupStepProvider {
  const AndroidDefaultSetupStepProvider();

  @override
  bool shouldProvide(SetupSystemInfo info) {
    return info.isAndroid && !_isSpecificManufacturer(info.manufacturer);
  }

  /// 已知需要单独适配的厂商，避免与专用提供器重复显示步骤。
  static bool _isSpecificManufacturer(String? manufacturer) {
    if (manufacturer == null) return false;
    final lower = manufacturer.toLowerCase();
    return lower.contains('xiaomi') ||
        lower.contains('redmi') ||
        lower.contains('vivo');
  }

  @override
  List<SetupStep> provide(SetupSystemInfo info) {
    return [
      SetupStep(
        tag: '第一步',
        icon: Icons.phone_android,
        title: '启用键盘',
        subtitle: '打开系统设置，启用 AI 回复助手',
        instruction: '设置 → 系统 → 语言和输入法 → 屏幕键盘 → 开启 AI 回复助手',
        actionTitle: '去设置',
        action: () {
          // TODO: 调用平台通道或 Intent 跳转到系统输入法设置。
          return null;
        },
      ),
      SetupStep(
        tag: '第二步',
        icon: Icons.keyboard_alt_outlined,
        title: '切换输入法',
        subtitle: '在输入框中长按地球/键盘图标选择 AI 回复助手',
        instruction: '任意输入框 → 切换输入法 → AI 回复助手',
        actionTitle: '检测是否已切换',
        action: () {
          // TODO: 查询当前默认输入法是否为本应用。
          return null;
        },
      ),
    ];
  }
}

/// 小米 / Redmi MIUI 引导步骤提供器示例。
///
/// MIUI 设置路径与原生 Android 不同，因此单独提供一个提供器。
/// 注册到 [SetupStepManager] 后，会在小米设备上替代默认 Android 流程。
class XiaomiMIUISetupStepProvider implements SetupStepProvider {
  const XiaomiMIUISetupStepProvider();

  @override
  bool shouldProvide(SetupSystemInfo info) {
    if (!info.isAndroid || info.manufacturer == null) return false;
    final lower = info.manufacturer!.toLowerCase();
    return lower.contains('xiaomi') || lower.contains('redmi');
  }

  @override
  List<SetupStep> provide(SetupSystemInfo info) {
    return [
      SetupStep(
        tag: '第一步',
        icon: Icons.phone_android,
        title: '启用键盘',
        subtitle: '打开小米设置，启用 AI 回复助手',
        instruction: '设置 → 更多设置 → 语言与输入法 → 键盘管理 → 开启 AI 回复助手',
        actionTitle: '去设置',
        action: () {
          // TODO: 跳转到 MIUI 输入法设置。
          return null;
        },
      ),
      SetupStep(
        tag: '第二步',
        icon: Icons.keyboard_alt_outlined,
        title: '切换输入法',
        subtitle: '在输入框中长按键盘图标选择 AI 回复助手',
        instruction: '任意输入框 → 键盘图标 → 切换输入法 → AI 回复助手',
        actionTitle: '检测是否已切换',
        action: () {
          // TODO: 查询当前默认输入法是否为本应用。
          return null;
        },
      ),
    ];
  }
}

/// vivo / OriginOS 引导步骤提供器示例。
class VivoOriginOSSetupStepProvider implements SetupStepProvider {
  const VivoOriginOSSetupStepProvider();

  @override
  bool shouldProvide(SetupSystemInfo info) {
    if (!info.isAndroid || info.manufacturer == null) return false;
    return info.manufacturer!.toLowerCase().contains('vivo');
  }

  @override
  List<SetupStep> provide(SetupSystemInfo info) {
    return [
      SetupStep(
        tag: '第一步',
        icon: Icons.phone_android,
        title: '启用键盘',
        subtitle: '打开 vivo 设置，启用 AI 回复助手',
        instruction: '设置 → 系统管理 → 输入法 → 默认键盘 → 开启 AI 回复助手',
        actionTitle: '去设置',
        action: () {
          // TODO: 跳转到 OriginOS 输入法设置。
          return null;
        },
      ),
      SetupStep(
        tag: '第二步',
        icon: Icons.keyboard_alt_outlined,
        title: '切换输入法',
        subtitle: '在输入框中长按键盘图标选择 AI 回复助手',
        instruction: '任意输入框 → 键盘图标 → 切换输入法 → AI 回复助手',
        actionTitle: '检测是否已切换',
        action: () {
          // TODO: 查询当前默认输入法是否为本应用。
          return null;
        },
      ),
    ];
  }
}

/// 引导步骤管理器。
///
/// 职责：
/// 1. 维护已注册的 [SetupStepProvider] 列表。
/// 2. 根据 [SetupSystemInfo] 筛选出适用的提供器。
/// 3. 汇总各提供器返回的步骤，并重新编号后交给 UI。
class SetupStepManager {
  SetupStepManager({List<SetupStepProvider>? providers}) {
    if (providers != null) {
      _providers.addAll(providers);
    }
  }

  final List<SetupStepProvider> _providers = [];

  /// 注册一个步骤提供器。
  void register(SetupStepProvider provider) {
    _providers.add(provider);
  }

  /// 批量注册步骤提供器。
  void registerAll(Iterable<SetupStepProvider> providers) {
    _providers.addAll(providers);
  }

  /// 根据 [info] 解析出最终需要展示的步骤列表。
  List<SetupStep> resolve(SetupSystemInfo info) {
    final visibleSteps = _providers
        .where((provider) => provider.shouldProvide(info))
        .expand((provider) => provider.provide(info))
        .toList();

    return _reTagSteps(visibleSteps);
  }

  List<SetupStep> _reTagSteps(List<SetupStep> steps) {
    // const chineseNumbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

    return steps.indexed.map((entry) {
      final (index, step) = entry;
      // final label = index < chineseNumbers.length
      //     ? chineseNumbers[index]
      //     : '${index + 1}';
      return SetupStep(
        tag: step.tag,
        icon: step.icon,
        title: step.title,
        subtitle: step.subtitle,
        instruction: step.instruction,
        actionTitle: step.actionTitle,
        action: step.action,
      );
    }).toList();
  }
}

/// 项目中默认使用的步骤管理器实例。
///
/// 放在这里是为了方便 UI 直接引用，也可以改用 GetIt 注入。
final defaultSetupStepManager = SetupStepManager()
  ..register(const IOSDefaultSetupStepProvider())
  ..register(const XiaomiMIUISetupStepProvider())
  ..register(const VivoOriginOSSetupStepProvider())
  ..register(const AndroidDefaultSetupStepProvider());
