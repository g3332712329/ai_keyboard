import 'package:ai_keyboard/config/configuration/configuration_info.dart';

/// 配置仓库抽象接口
///
/// 负责配置数据的持久化读写，支持本地存储和云端存储两种实现。
/// 当前阶段使用本地存储实现，云端存储接口已预留，后续可无缝切换或双写。
abstract class ConfigurationRepository {


  /// 获取完整配置信息
  ///
  /// 配置不存在时返回默认空配置（所有字段为 null 或默认值）。
  Future<ConfigurationInfo> getConfiguration();

  /// 保存完整配置信息
  ///
  /// [config] - 要保存的配置对象，会覆盖已有配置。
  Future<void> saveConfiguration(ConfigurationInfo config);

  /// 函数式更新配置
  ///
  /// [updater] 接收当前配置，返回更新后的新配置。
  /// 返回更新后的完整配置对象，避免调用方再次 `getConfiguration()`。
  ///
  /// 适用于 freezed 的 copyWith 模式：
  /// ```dart
  /// final updated = await repository.updateConfiguration(
  ///   (current) => current.copyWith(baseUrl: 'https://api.example.com'),
  /// );
  /// ```
  Future<ConfigurationInfo> updateConfiguration(
    ConfigurationInfo Function(ConfigurationInfo current) updater,
  );

  /// 清空所有配置数据
  Future<void> clearConfiguration();
}
