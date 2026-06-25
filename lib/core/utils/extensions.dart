import 'package:flutter/material.dart';

/// 扩展：BuildContext 快捷方法
extension BuildContextExt on BuildContext {
  /// 获取主题
  ThemeData get theme => Theme.of(this);

  /// 获取颜色方案
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 获取文本主题
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// 获取屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 获取屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 获取底部安全区域高度
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  /// 显示 SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// 扩展：String 快捷方法
extension StringExt on String {
  /// 限制字符串长度，超出部分显示省略号
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// 检查是否为空或仅包含空白字符
  bool get isBlank => trim().isEmpty;

  /// 检查是否非空且不只包含空白字符
  bool get isNotBlank => !isBlank;
}
