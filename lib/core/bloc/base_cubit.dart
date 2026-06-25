import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

export 'app_effects.dart' show AppEffects, ToastType;
import 'app_effects.dart';

/// 带 UI Effect 能力的 Cubit 基类
///
/// 所有需要展示 Loading Dialog 或 Toast 的 Cubit 都应继承此类。
/// Effect 是一次性事件，不会持久化到 State 中。
///
/// 使用方式：
/// ```dart
/// class SettingCubit extends BaseCubit<SettingState> {
///   void testConnection() async {
///     showLoading(message: '正在测试...', dismissible: false);
///     // ... 异步操作
///     hideLoading();
///     showToast('连接成功', type: ToastType.success);
///   }
/// }
/// ```
abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  final _effectController = StreamController<AppEffects>.broadcast();

  /// Effect 流，供 UI 层监听
  Stream<AppEffects> get effect => _effectController.stream;

  /// 显示 Loading Dialog
  void showLoading({String? message, bool dismissible = false}) {
    if (!_effectController.isClosed) {
      _effectController.add(
        AppEffects.showLoading(message: message, dismissible: dismissible),
      );
    }
  }

  /// 隐藏 Loading Dialog
  void hideLoading() {
    if (!_effectController.isClosed) {
      _effectController.add(const AppEffects.hideLoading());
    }
  }

  /// 显示 Toast / SnackBar
  void showToast(String message, {ToastType type = ToastType.info}) {
    if (!_effectController.isClosed) {
      _effectController.add(
        AppEffects.showToast(message: message, type: type),
      );
    }
  }

  @override
  Future<void> close() async {
    await _effectController.close();
    return super.close();
  }
}
