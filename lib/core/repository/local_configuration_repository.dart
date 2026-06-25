import 'dart:convert';

import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/utils/shares_local_data/shares_local_data.dart';

/// 本地配置仓库实现
///
/// 基于 [SharesLocalData]（MMKV）进行配置的本地持久化存储。
/// 配置数据以 JSON 字符串形式存储，读写时进行序列化/反序列化。
class LocalConfigurationRepository implements ConfigurationRepository {
  final SharesLocalData _localData;

  /// 存储配置数据所用的 key
  final String storageKey = 'configuration';

  LocalConfigurationRepository({required this._localData});

  @override
  Future<ConfigurationInfo> getConfiguration() async {
    final jsonString = await _localData.getString(storageKey);
    if (jsonString == null || jsonString.isEmpty) {
      return const ConfigurationInfo();
    }
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ConfigurationInfo.fromJson(json);
    } catch (_) {
      // JSON 解析失败时返回默认配置，避免崩溃
      return const ConfigurationInfo();
    }
  }

  @override
  Future<void> saveConfiguration(ConfigurationInfo config) async {
    final jsonString = jsonEncode(config.toJson());
    await _localData.putString(storageKey, jsonString);
  }

  @override
  Future<ConfigurationInfo> updateConfiguration(
    ConfigurationInfo Function(ConfigurationInfo current) updater,
  ) async {
    final current = await getConfiguration();
    final updated = updater(current);
    await saveConfiguration(updated);
    return updated;
  }

  @override
  Future<void> clearConfiguration() async {
    await _localData.remove(storageKey);
  }
}
