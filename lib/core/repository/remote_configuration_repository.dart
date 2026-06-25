import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';

/// 云端配置仓库实现（预留）
///
/// 当前为占位实现，后续接入云端同步服务时替换为真实逻辑。
/// 现阶段调用任何方法都会抛出 [UnsupportedError]。
class RemoteConfigurationRepository implements ConfigurationRepository {
  @override
  Future<ConfigurationInfo> getConfiguration() async {
    throw UnsupportedError(
      'RemoteConfigurationRepository.getConfiguration() 尚未实现，'
      '当前阶段请使用 LocalConfigurationRepository。',
    );
  }

  @override
  Future<void> saveConfiguration(ConfigurationInfo config) async {
    throw UnsupportedError(
      'RemoteConfigurationRepository.saveConfiguration() 尚未实现，'
      '当前阶段请使用 LocalConfigurationRepository。',
    );
  }

  @override
  Future<ConfigurationInfo> updateConfiguration(
    ConfigurationInfo Function(ConfigurationInfo current) updater,
  ) async {
    throw UnsupportedError(
      'RemoteConfigurationRepository.updateConfiguration() 尚未实现，'
      '当前阶段请使用 LocalConfigurationRepository。',
    );
  }

  @override
  Future<void> clearConfiguration() async {
    throw UnsupportedError(
      'RemoteConfigurationRepository.clearConfiguration() 尚未实现，'
      '当前阶段请使用 LocalConfigurationRepository。',
    );
  }
}
