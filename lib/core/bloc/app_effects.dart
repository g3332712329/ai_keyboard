import 'package:freezed_annotation/freezed_annotation.dart';

part 'g/app_effects.freezed.dart';

@freezed
sealed class AppEffects with _$AppEffects {
  const factory AppEffects.showLoading({
    String? message,
    @Default(false) bool dismissible,
  }) = ShowLoadingEffect;

  const factory AppEffects.hideLoading() = HideLoadingEffect;

  const factory AppEffects.showToast({
    required String message,
    @Default(ToastType.info) ToastType type,
  }) = ShowToastEffect;
}

enum ToastType { success, error, warning, info }
