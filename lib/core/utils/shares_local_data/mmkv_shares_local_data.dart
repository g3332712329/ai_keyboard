import 'dart:async';
import 'dart:io';

import 'package:ai_keyboard/channel/only_ios_event_channel.g.dart';
import 'package:ai_keyboard/core/utils/shares_local_data/shares_local_data.dart';
import 'package:mmkv/mmkv.dart';

/// 基于腾讯 MMKV 的本地存储实现
///
/// MMKV 特点：高性能、支持多进程、数据加密可选。
/// 适用于高频读写的键值场景。
class MmkvSharesLocalData implements SharesLocalData {
  late MMKV _mmkv;

  @override
  FutureOr<bool> init() async {
    // iOS 上必须通过 Pigeon 通道获取 App Group 容器的真实文件路径，
    // 这样 MMKV 才能被键盘扩展（Keyboard Extension）读取。
    // Android 使用默认初始化即可，无需 groupDir。
    String? groupDir;
    if (Platform.isIOS) {
      groupDir = await IosGroupAppEventChannel().getAppGroupsDir();
    }

    await MMKV.initialize(groupDir: groupDir);
    // 使用具名多进程实例，iOS 键盘扩展才能读取到同一份数据。
    // mmapID 必须与键盘扩展中初始化时传入的一致。
    _mmkv = MMKV(
      'ai_keyboard_config',
      mode: MMKVMode.MULTI_PROCESS_MODE,
    );
    return true;
  }

  @override
  FutureOr<bool> containsKey(String key) {
    return _mmkv.containsKey(key);
  }

  @override
  FutureOr<bool?> getBool(String key, {bool? defaultValue}) {
    if (!_mmkv.containsKey(key)) {
      return defaultValue;
    }
    return _mmkv.decodeBool(key, defaultValue: defaultValue ?? false);
  }

  @override
  FutureOr<double?> getDouble(String key, {double? defaultValue}) {
    if (!_mmkv.containsKey(key)) {
      return defaultValue;
    }
    return _mmkv.decodeDouble(key, defaultValue: defaultValue ?? 0);
  }

  @override
  FutureOr<int?> getInt(String key, {int? defaultValue}) {
    if (!_mmkv.containsKey(key)) {
      return defaultValue;
    }
    return _mmkv.decodeInt(key, defaultValue: defaultValue ?? 0);
  }

  @override
  FutureOr<String?> getString(String key, {String? defaultValue}) {
    if (!_mmkv.containsKey(key)) {
      return defaultValue;
    }
    return _mmkv.decodeString(key) ?? defaultValue;
  }

  @override
  FutureOr<bool> putBool(String key, bool value) {
    return _mmkv.encodeBool(key, value);
  }

  @override
  FutureOr<bool> putDouble(String key, double value) {
    return _mmkv.encodeDouble(key, value);
  }

  @override
  FutureOr<bool> putInt(String key, int value) {
    return _mmkv.encodeInt(key, value);
  }

  @override
  FutureOr<bool> putString(String key, String value) {
    return _mmkv.encodeString(key, value);
  }

  @override
  FutureOr<bool> remove(String key) {
    _mmkv.removeValue(key);
    return true;
  }

  @override
  FutureOr<bool> removeAll() {
    _mmkv.clearAll();
    return true;
  }
}
