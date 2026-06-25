part of 'keyboard_cubit.dart';

/// 键盘面板状态
@freezed
abstract class KeyboardState with _$KeyboardState {
  const factory KeyboardState.initial() = _Initial;

  const factory KeyboardState.loading() = _Loading;

  const factory KeyboardState.data({
    required List<ReplyStyle> styles,
    required ReplyStyle? selectedStyle,
    required String inputText,

    /// 当前正在生成回复的风格 ID，null 表示没有风格正在生成
    int? generatingStyleId,
  }) = _Data;
}
