// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../configuration_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConfigurationInfo _$ConfigurationInfoFromJson(Map<String, dynamic> json) =>
    _ConfigurationInfo(
      version: (json['version'] as num?)?.toInt() ?? 1,
      platforms:
          (json['platforms'] as List<dynamic>?)
              ?.map((e) => AiPlatform.fromJson(e as Map<String, dynamic>))
              .toList() ??
          AppConstants.defaultAiPlatform,
      preferences:
          (json['preferences'] as List<dynamic>?)
              ?.map((e) => AppPreference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          AppConstants.defaultAppPreference,
      replyStyles:
          (json['replyStyles'] as List<dynamic>?)
              ?.map((e) => ReplyStyle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          AppConstants.defaultReplyStyles,
    );

Map<String, dynamic> _$ConfigurationInfoToJson(_ConfigurationInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'platforms': instance.platforms,
      'preferences': instance.preferences,
      'replyStyles': instance.replyStyles,
    };

_AiPlatform _$AiPlatformFromJson(Map<String, dynamic> json) => _AiPlatform(
  name: json['name'] as String? ?? '',
  baseUrl: json['baseUrl'] as String? ?? '',
  apiKey: json['apiKey'] as String? ?? '',
  models:
      (json['models'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  selectedModel: json['selectedModel'] as String? ?? '',
  enable: json['enable'] as bool? ?? false,
);

Map<String, dynamic> _$AiPlatformToJson(_AiPlatform instance) =>
    <String, dynamic>{
      'name': instance.name,
      'baseUrl': instance.baseUrl,
      'apiKey': instance.apiKey,
      'models': instance.models,
      'selectedModel': instance.selectedModel,
      'enable': instance.enable,
    };

_ReplyStyle _$ReplyStyleFromJson(Map<String, dynamic> json) => _ReplyStyle(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  prompt: json['prompt'] as String? ?? '',
  isCustomization: json['isCustomization'] as bool? ?? false,
);

Map<String, dynamic> _$ReplyStyleToJson(_ReplyStyle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'prompt': instance.prompt,
      'isCustomization': instance.isCustomization,
    };

_AppPreference _$AppPreferenceFromJson(Map<String, dynamic> json) =>
    _AppPreference(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
    );

Map<String, dynamic> _$AppPreferenceToJson(_AppPreference instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'desc': instance.desc,
      'isOpen': instance.isOpen,
    };
