part of 'setting_cubit.dart';

@freezed
class SettingState with _$SettingState {
  const factory SettingState.initial() = _Initial;

  const factory SettingState.loading() = _Loading;

  const factory SettingState.data({
    required AiPlatform platform,
    required List<AiPlatform> platforms,
    required List<AppPreference> preferences,
    required List<ReplyStyle> replyStyles,
  }) = _Data;

  const factory SettingState.error(String message) = _Error;
}
