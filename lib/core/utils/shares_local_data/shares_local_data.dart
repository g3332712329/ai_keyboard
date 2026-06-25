/// 本地共享数据 接口
///
/// 封装底层存储引擎（MMKV / SharedPreferences / Hive 等），
/// 提供统一的键值读写能力。
///
/// 使用 [FutureOr] 作为返回值类型，以便兼容同步或异步存储引擎：
/// - MMKV 为同步操作
/// - SharedPreferences / Hive 为异步操作
///
/// 调用方统一使用 `await` 即可，无需关心底层引擎的同步/异步差异。
library;

import 'dart:async';

abstract class SharesLocalData {
  /// 初始化存储引擎
  ///
  /// 必须在应用启动时调用一次。
  FutureOr<bool> init();

  /// 判断指定 key 是否存在
  FutureOr<bool> containsKey(String key);

  /// 存储布尔值
  FutureOr<bool> putBool(String key, bool value);

  /// 读取布尔值
  ///
  /// [defaultValue] - key 不存在时返回的默认值，不传则返回 null
  FutureOr<bool?> getBool(String key, {bool? defaultValue});

  /// 存储字符串
  FutureOr<bool> putString(String key, String value);

  /// 读取字符串
  ///
  /// [defaultValue] - key 不存在时返回的默认值，不传则返回 null
  FutureOr<String?> getString(String key, {String? defaultValue});

  /// 存储整型
  FutureOr<bool> putInt(String key, int value);

  /// 读取整型
  ///
  /// [defaultValue] - key 不存在时返回的默认值，不传则返回 null
  FutureOr<int?> getInt(String key, {int? defaultValue});

  /// 存储浮点型
  FutureOr<bool> putDouble(String key, double value);

  /// 读取浮点型
  ///
  /// [defaultValue] - key 不存在时返回的默认值，不传则返回 null
  FutureOr<double?> getDouble(String key, {double? defaultValue});

  /// 删除指定 key
  FutureOr<bool> remove(String key);

  /// 清空所有数据
  FutureOr<bool> removeAll();
}
