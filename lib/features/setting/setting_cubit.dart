import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/bloc/base_cubit.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_dart/openai_dart.dart';

part 'g/setting_cubit.freezed.dart';
part 'setting_state.dart';

class SettingCubit extends BaseCubit<SettingState> {
  final ConfigurationRepository _configurationRepository;

  SettingCubit(this._configurationRepository)
    : super(const SettingState.initial());

  /// 加载 AI 配置数据
  Future<void> loadConfig() async {
    emit(const SettingState.loading());
    try {
      var configuration = await _configurationRepository.getConfiguration();

      // 是否需要重新获取平台配置
      var needUpdateCurrentConfig = false;
      // 获取当前启用的 AI 平台，若不存在则默认启用第一个
      final currentPlatform = configuration.platforms.firstWhere(
        (element) {
          return element.enable;
        },
        orElse: () {
          needUpdateCurrentConfig = true;
          final defaultPlatform = configuration.platforms.first.copyWith(
            enable: true,
          );
          return defaultPlatform;
        },
      );

      // 更新当前平台启用。
      if (needUpdateCurrentConfig) {
        configuration = await _configurationRepository.updateConfiguration(
          (current) {
            return current.copyWith(
              platforms: current.platforms.map((e) {
                return e.copyWith(enable: e.name == currentPlatform.name);
              }).toList(),
            );
          },
        );
      }

      var platforms = configuration.platforms;
      // 首次使用：平台列表为空时，写入默认平台配置
      if (platforms.isEmpty) {
        platforms = AppConstants.defaultAiPlatform;
        configuration = await _configurationRepository.updateConfiguration(
          (current) => current.copyWith(platforms: platforms),
        );
      }

      // 首次使用：回复风格为空时，写入默认风格配置
      var replyStyles = configuration.replyStyles;
      if (replyStyles.isEmpty) {
        replyStyles = AppConstants.defaultReplyStyles;
        configuration = await _configurationRepository.updateConfiguration(
          (current) => current.copyWith(replyStyles: replyStyles),
        );
      }

      emit(
        SettingState.data(
          platform: currentPlatform,
          platforms: platforms,
          preferences: configuration.preferences,
          replyStyles: replyStyles,
        ),
      );
    } catch (e) {
      emit(SettingState.error('加载配置失败：$e'));
    }
  }

  /// 修改 AI 平台
  Future<void> changePlatform(AiPlatform selectPlatform) async {
    try {
      final configuration = await _configurationRepository.getConfiguration();

      final platforms = configuration.platforms
          .map((e) => e.copyWith(enable: e.name == selectPlatform.name))
          .toList();

      await _configurationRepository.updateConfiguration(
        (current) => current.copyWith(platforms: platforms),
      );

      final newPlatform = platforms.firstWhere(
        (element) => element.name == selectPlatform.name,
        orElse: () => platforms.first,
      );

      final newState = state.map(
        initial: (_) => SettingState.data(
          platform: newPlatform,
          platforms: platforms,
          preferences: configuration.preferences,
          replyStyles: configuration.replyStyles,
        ),
        loading: (_) => SettingState.data(
          platform: newPlatform,
          platforms: platforms,
          preferences: configuration.preferences,
          replyStyles: configuration.replyStyles,
        ),
        data: (value) =>
            value.copyWith(platform: newPlatform, platforms: platforms),
        error: (_) => SettingState.data(
          platform: newPlatform,
          platforms: platforms,
          preferences: configuration.preferences,
          replyStyles: configuration.replyStyles,
        ),
      );
      emit(newState);
    } catch (e) {
      showToast('切换平台失败', type: ToastType.error);
    }
  }

  /// 更新偏好设置开关状态
  Future<void> updatePreference(String key, bool isOpen) async {
    try {
      final configuration = await _configurationRepository.updateConfiguration(
        (current) {
          final newPreferences = current.preferences.map((p) {
            if (p.key == key) {
              return p.copyWith(isOpen: isOpen);
            }
            return p;
          }).toList();
          return current.copyWith(preferences: newPreferences);
        },
      );

      state.mapOrNull(
        data: (value) {
          emit(value.copyWith(preferences: configuration.preferences));
        },
      );
    } catch (e) {
      showToast('更新偏好设置失败', type: ToastType.error);
    }
  }

  /// 测试 API 连接（预留）
  Future<bool> testConnection() async {
    // TODO: 实现 API 连接测试逻辑
    // 1. 获取当前启用的平台配置
    // 2. 使用 Dio 发送测试请求
    // 3. 返回测试结果
    return false;
  }

  /// 保存平台 API Key
  Future<void> savePlatformApiKey(String apiKey) async {
    showLoading(message: '正在验证 API Key...', dismissible: false);

    try {
      var configuration = await _configurationRepository.getConfiguration();
      final currentPlatform = configuration.platforms.firstWhere(
        (element) => element.enable,
        orElse: () => configuration.platforms.first,
      );

      final platformClient = OpenAIClient(
        config: OpenAIConfig(
          baseUrl: currentPlatform.baseUrl,
          authProvider: ApiKeyProvider(apiKey),
          connectTimeout: const Duration(seconds: 10),
          timeout: const Duration(seconds: 10),
        ),
      );

      List<Model> modelList = [];
      try {
        final response = await platformClient.models.list();
        modelList = response.data;
      } finally {
        platformClient.close();
      }

      if (modelList.isEmpty) {
        showToast('API Key 不可用', type: ToastType.error);
        return;
      }

      // 保存 api key 和模型
      final models = modelList.map((e) => e.id).where((modelId) {
        return true;
      },).toList();
      final newConfig = await _configurationRepository.updateConfiguration(
        (current) {
          return current.copyWith(
            platforms: current.platforms.map((e) {
              if (e.name == currentPlatform.name) {
                return e.copyWith(
                  apiKey: apiKey,
                  models: models,
                  selectedModel: models.last,
                );
              }
              return e;
            }).toList(),
          );
        },
      );

      state.mapOrNull(
        data: (value) {
          emit(
            value.copyWith(
              platform: newConfig.platforms.firstWhere(
                (element) => element.enable,
                orElse: () => newConfig.platforms.first,
              ),
              platforms: newConfig.platforms,
            ),
          );
        },
      );

      showToast('连接成功', type: ToastType.success);
    } catch (e) {
      showToast('连接失败', type: ToastType.error);
    } finally {
      hideLoading();
    }
  }

  /// 保存平台使用的模型
  void savePlatformModel(String selectModel) async {
    try {
      final configuration = await _configurationRepository.updateConfiguration(
        (current) {
          return current.copyWith(
            platforms: current.platforms.map((e) {
              if (e.enable && e.models.contains(selectModel)) {
                return e.copyWith(selectedModel: selectModel);
              }
              return e;
            }).toList(),
          );
        },
      );

      state.mapOrNull(
        data: (value) {
          emit(
            value.copyWith(
              platform: configuration.platforms.firstWhere(
                (element) => element.enable,
                orElse: () => configuration.platforms.first,
              ),
              platforms: configuration.platforms,
            ),
          );
        },
      );
    } catch (e) {
      showToast('保存模型失败', type: ToastType.error);
    }
  }

  /// 刷新平台模型列表（需要 API Key）
  Future<void> refreshPlatformModels() async {
    // TODO: 通过 API Key 调用 /v1/models 获取可用模型列表
  }
}
