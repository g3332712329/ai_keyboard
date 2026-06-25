import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'g/configuration_info.freezed.dart';
part 'g/configuration_info.g.dart';

@freezed
abstract class ConfigurationInfo with _$ConfigurationInfo {
  const factory ConfigurationInfo({
    /// 配置数据版本号，用于后续数据结构变更时的迁移兼容
    @JsonKey(name: 'version') @Default(1) int version,

    /// AI 平台配置列表
    @JsonKey(name: 'platforms')
    @Default(AppConstants.defaultAiPlatform)
    List<AiPlatform> platforms,

    /// 应用偏好设置
    @JsonKey(name: 'preferences')
    @Default(AppConstants.defaultAppPreference)
    List<AppPreference> preferences,

    /// 回复风格配置（9 种内置风格）
    @JsonKey(name: 'replyStyles')
    @Default(AppConstants.defaultReplyStyles)
    List<ReplyStyle> replyStyles,
  }) = _ConfigurationInfo;

  factory ConfigurationInfo.fromJson(Map<String, Object?> json) =>
      _$ConfigurationInfoFromJson(json);
}

@freezed
abstract class AiPlatform with _$AiPlatform {
  const factory AiPlatform({
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'baseUrl') @Default('') String baseUrl,
    @JsonKey(name: 'apiKey') @Default('') String apiKey,

    /// 该平台可用的模型列表（内置默认值 + API 刷新）
    @JsonKey(name: 'models') @Default([]) List<String> models,

    /// 当前选中的模型
    @JsonKey(name: 'selectedModel') @Default('') String selectedModel,

    /// 是否启用该平台
    @JsonKey(name: 'enable') @Default(false) bool enable,
  }) = _AiPlatform;

  factory AiPlatform.fromJson(Map<String, dynamic> json) =>
      _$AiPlatformFromJson(json);
}

@freezed
abstract class ReplyStyle with _$ReplyStyle {
  const factory ReplyStyle({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') @Default('') String name,
    /// System Prompt，用于风格编辑功能
    @JsonKey(name: 'prompt') @Default('') String prompt,
    /// 是否是用户自定义风格
    @JsonKey(name: 'isCustomization') @Default(false) bool isCustomization,
  }) = _ReplyStyle;

  factory ReplyStyle.fromJson(Map<String, dynamic> json) =>
      _$ReplyStyleFromJson(json);
}

@freezed
abstract class AppPreference with _$AppPreference {
  const factory AppPreference({
    @JsonKey(name: 'key') @Default('') String key,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'desc') @Default('') String desc,

    /// 开关状态，非空，默认关闭
    @JsonKey(name: 'isOpen') @Default(false) bool isOpen,
  }) = _AppPreference;

  factory AppPreference.fromJson(Map<String, dynamic> json) =>
      _$AppPreferenceFromJson(json);
}
