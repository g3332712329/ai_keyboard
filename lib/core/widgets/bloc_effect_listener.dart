import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_effects.dart';
import '../bloc/base_cubit.dart';

/// 自动监听 Cubit Effect 并展示 UI
///
/// 功能：
/// - ShowLoadingEffect → 弹出 Loading Dialog（防重复、防误触）
/// - HideLoadingEffect → 关闭 Loading Dialog
/// - ShowToastEffect   → 弹出 SnackBar（带图标、颜色区分类型）
///
/// 使用方式：包裹在 BlocProvider 内层，靠近页面根部即可。
/// ```dart
/// BlocProvider(
///   create: (_) => sl<SettingCubit>()..loadConfig(),
///   child: BlocEffectListener<SettingCubit, SettingState>(
///     child: const _Page(),
///   ),
/// )
/// ```
class BlocEffectListener<C extends BaseCubit<S>, S> extends StatefulWidget {
  final Widget child;

  const BlocEffectListener({super.key, required this.child});

  @override
  State<BlocEffectListener<C, S>> createState() =>
      _BlocEffectListenerState<C, S>();
}

class _BlocEffectListenerState<C extends BaseCubit<S>, S>
    extends State<BlocEffectListener<C, S>> {
  bool _isLoadingShown = false;
  StreamSubscription? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription?.cancel();
    final cubit = context.read<C>();
    _subscription = cubit.effect.listen(_handleEffect, onError: (_) {});
  }

  void _handleEffect(AppEffects effect) {
    if (!mounted) return;

    switch (effect) {
      case ShowLoadingEffect(:final message, :final dismissible):
        if (_isLoadingShown) return; // 防重复弹出

        _isLoadingShown = true;
        showDialog(
          context: context,
          barrierDismissible: dismissible,
          builder: (_) => PopScope(
            canPop: dismissible,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) _isLoadingShown = false;
            },
            child: AlertDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      message ?? '加载中...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).then((_) => _isLoadingShown = false);

      case HideLoadingEffect():
        if (_isLoadingShown) {
          _isLoadingShown = false;
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) {
            navigator.pop();
          }
        }

      case ShowToastEffect(:final message, :final type):
        final color = switch (type) {
          ToastType.success => const Color(0xFF2E7D32),
          ToastType.error => const Color(0xFFC62828),
          ToastType.warning => const Color(0xFFEF6C00),
          ToastType.info => const Color(0xFF1565C0),
        };
        final icon = switch (type) {
          ToastType.success => Icons.check_circle_outline_rounded,
          ToastType.error => Icons.error_outline_rounded,
          ToastType.warning => Icons.warning_amber_rounded,
          ToastType.info => Icons.info_outline_rounded,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(message)),
              ],
            ),
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
