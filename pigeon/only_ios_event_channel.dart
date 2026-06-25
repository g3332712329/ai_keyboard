import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/channel/only_ios_event_channel.g.dart',
    swiftOut: 'ios/runner/channel/OnlyIosEventChannel.g.swift',
  ),
)
@HostApi()
abstract class IosGroupAppEventChannel {
  /// 获取ios端app groups路径
  String getAppGroupsDir();

  /// 打开软键盘设置页面
  /// return true打开成功
  /// return false 打开失败
  bool openKeyboardSettings();

  /// 检查软键盘扩展是否已经启用
  /// return true已经启用
  /// return false没有启用
  bool isKeyboardExtensionEnabled();
}
