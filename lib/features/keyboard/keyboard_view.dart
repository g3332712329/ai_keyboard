import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/widgets/bloc_effect_listener.dart';
import 'package:ai_keyboard/features/keyboard/keyboard_cubit.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AI 回复键盘面板
///
/// 提供风格选择、对话内容输入、粘贴/删除/清空/生成回复等能力。
///
/// [onGenerated]：当 AI 生成回复后，通过该回调将结果返回给上层 Widget。
class KeyboardView extends StatelessWidget {
  /// 生成回复成功后的回调
  final ValueChanged<String> onGenerated;

  final VoidCallback? onDelete;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  const KeyboardView({
    super.key,
    required this.onGenerated,
    this.onDelete,
    this.onClear,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KeyboardCubit>(
      create: (_) =>
          KeyboardCubit(sl.get<ConfigurationRepository>())..loadStyles(),
      child: BlocEffectListener<KeyboardCubit, KeyboardState>(
        child: _View(
          onGenerated: onGenerated,
          onDelete: onDelete,
          onClear: onClear,
          onSubmit: onSubmit,
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  final ValueChanged<String> onGenerated;
  final VoidCallback? onDelete;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  const _View({
    required this.onGenerated,
    this.onDelete,
    this.onClear,
    this.onSubmit,
  });

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _inputController = TextEditingController();
  final _pageController = PageController();

  @override
  void dispose() {
    _inputController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              _buildInputArea(colorScheme),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 8,
                        children: [
                          _buildPasteButton(colorScheme),
                          Expanded(child: _buildStylePager(colorScheme)),
                        ],
                      ),
                    ),
                    _buildActionColumn(colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 输入框区域（只读，仅展示粘贴内容）
  Widget _buildInputArea(ColorScheme colorScheme) {
    return BlocListener<KeyboardCubit, KeyboardState>(
      listenWhen: (previous, current) {
        return previous.mapOrNull(data: (v) => v.inputText) !=
            current.mapOrNull(data: (v) => v.inputText);
      },
      listener: (context, state) {
        state.mapOrNull(
          data: (value) {
            if (_inputController.text != value.inputText) {
              _inputController.text = value.inputText;
              _inputController.selection = TextSelection.collapsed(
                offset: _inputController.text.length,
              );
            }
          },
        );
      },
      child: TextField(
        controller: _inputController,
        readOnly: true,
        maxLines: 1,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: '粘贴对话内容以生成回复...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: () {
          // TODO: 输入框点击功能预留
        },
      ),
    );
  }

  /// 粘贴内容按钮
  Widget _buildPasteButton(ColorScheme colorScheme) {
    return SizedBox(
      height: 40,
      child: FilledButton.icon(
        onPressed: () {
          context.read<KeyboardCubit>().pasteContent();
        },
        icon: Icon(Icons.content_paste, size: 18, color: colorScheme.onSurface),
        label: Text('粘贴内容', style: TextStyle(color: colorScheme.onSurface)),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  /// 风格分页网格（每页 3x3，左右滑动）
  ///
  /// 使用 [Column] + [Expanded] [Row] 替代 [GridView]，
  /// 让每行/每列高度按剩余空间均分，避免固定宽高比导致的溢出。
  Widget _buildStylePager(ColorScheme colorScheme) {
    return BlocBuilder<KeyboardCubit, KeyboardState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          data: (value) {
            final styles = value.styles;
            if (styles.isEmpty) {
              return Center(
                child: Text(
                  '暂无风格',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              );
            }

            final pageCount = (styles.length / 9).ceil();
            final generatingId = value.generatingStyleId;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, pageIndex) {
                      final start = pageIndex * 9;
                      final end = (start + 9).clamp(0, styles.length);
                      final pageStyles = styles.sublist(start, end);

                      return _StylePage(
                        styles: pageStyles,
                        generatingId: generatingId,
                        colorScheme: colorScheme,
                        onStyleTap: (style) {
                          context.read<KeyboardCubit>().generateByStyle(
                            style,
                            onGenerated: widget.onGenerated,
                          );
                        },
                      );
                    },
                  ),
                ),
                if (pageCount > 1)
                  _PageIndicator(
                    pageCount: pageCount,
                    controller: _pageController,
                    colorScheme: colorScheme,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// 右侧操作列：删除、清空、发送
  Widget _buildActionColumn(ColorScheme colorScheme) {
    return SizedBox(
      width: 64,
      child: BlocBuilder<KeyboardCubit, KeyboardState>(
        builder: (context, state) {
          final isBusy =
              state.mapOrNull(data: (v) => v.generatingStyleId) != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              _IconActionButton(
                icon: Icons.backspace_outlined,
                label: '删除',
                colorScheme: colorScheme,
                enabled: !isBusy,
                onTap: () {
                  widget.onDelete?.call();
                },
              ),
              _IconActionButton(
                icon: Icons.delete_outline_rounded,
                label: '清空',
                colorScheme: colorScheme,
                enabled: !isBusy,
                onTap: () {
                  widget.onClear?.call();
                },
              ),
              Expanded(
                child: _buildSendButton(
                  colorScheme: colorScheme,
                  isBusy: isBusy,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 发送按钮
  Widget _buildSendButton({
    required ColorScheme colorScheme,
    required bool isBusy,
  }) {
    return FilledButton(
      onPressed: isBusy
          ? null
          : () {
              widget.onSubmit?.call();
            },
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
        foregroundColor: colorScheme.onPrimary,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        '发送',
        style: TextStyle(fontSize: 12, color: colorScheme.onPrimary),
      ),
    );
  }
}

/// 单页风格网格（3x3）
///
/// 每行和每列均使用 [Expanded] 均分空间，避免溢出。
class _StylePage extends StatelessWidget {
  final List<ReplyStyle> styles;
  final int? generatingId;
  final ColorScheme colorScheme;
  final ValueChanged<ReplyStyle> onStyleTap;

  const _StylePage({
    required this.styles,
    required this.generatingId,
    required this.colorScheme,
    required this.onStyleTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var row = 0; row < 3; row++) {
      final rowStyles = <Widget>[];
      for (var col = 0; col < 3; col++) {
        final index = row * 3 + col;
        if (index < styles.length) {
          final style = styles[index];
          final isGenerating = style.id == generatingId;
          final isBusy = generatingId != null && !isGenerating;
          rowStyles.add(
            Expanded(
              child: _StyleChip(
                style: style,
                isGenerating: isGenerating,
                colorScheme: colorScheme,
                onTap: isBusy ? null : () => onStyleTap(style),
              ),
            ),
          );
        } else {
          rowStyles.add(const Expanded(child: SizedBox.shrink()));
        }

        if (col < 2) {
          rowStyles.add(const SizedBox(width: 8));
        }
      }

      rows.add(
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowStyles,
          ),
        ),
      );
      if (row < 2) {
        rows.add(const SizedBox(height: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// 风格标签按钮
class _StyleChip extends StatelessWidget {
  final ReplyStyle style;
  final bool isGenerating;
  final ColorScheme colorScheme;
  final VoidCallback? onTap;

  const _StyleChip({
    required this.style,
    required this.isGenerating,
    required this.colorScheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isGenerating
        ? colorScheme.primary
        : colorScheme.surface;
    final foregroundColor = isGenerating
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: isGenerating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  style.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

/// 右侧图标操作按钮
class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _IconActionButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Material(
        color: enabled
            ? colorScheme.surface
            : colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            size: 22,
            color: enabled
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// 页面指示器
class _PageIndicator extends StatefulWidget {
  final int pageCount;
  final PageController controller;
  final ColorScheme colorScheme;

  const _PageIndicator({
    required this.pageCount,
    required this.controller,
    required this.colorScheme,
  });

  @override
  State<_PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    final page = widget.controller.page?.round() ?? 0;
    if (page != _currentPage && mounted) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pageCount, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 12 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? widget.colorScheme.primary
                : widget.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
