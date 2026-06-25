import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/widgets/bloc_effect_listener.dart';
import 'package:ai_keyboard/features/style/style_cubit.dart';
import 'package:ai_keyboard/features/style/widget/style_customization_dialog.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StyleCubit>(
      create: (context) {
        return StyleCubit(sl.get<ConfigurationRepository>())..initData();
      },
      child: const BlocEffectListener<StyleCubit, StyleState>(child: _Page()),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  /// 每个风格项对应的输入框控制器（页面级管理，避免 body 重建丢失）
  final List<TextEditingController> _controllers = [];

  void _initControllers(List<ReplyStyle> styles) {
    if (_controllers.length == styles.length) return;
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    for (final style in styles) {
      _controllers.add(TextEditingController(text: style.prompt));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<StyleCubit, StyleState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.when(
              initial: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (message) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '数据加载失败!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          context.read<StyleCubit>().initData();
                        },
                        label: const Text('重试'),
                      ),
                    ],
                  ),
                );
              },
              data: (styles) {
                // 初始化控制器
                _initControllers(styles);
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text('风格编辑'),
                      actions: [
                        IconButton(
                          onPressed: _openCustomizationDialog,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: ExpansionPanelList.radio(
                        elevation: 0,
                        expandedHeaderPadding: EdgeInsets.zero,
                        dividerColor: Colors.transparent,
                        materialGapSize: 8,
                        children: [
                          for (var i = 0; i < styles.length; i++)
                            _buildPanel(context, index: i, style: styles[i]),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 打开自定义风格弹窗
  void _openCustomizationDialog() async {
    final result = await showDialog<({String name, String prompt})?>(
      context: context,
      builder: (context) => const StyleCustomizationDialog(),
    );

    if (result != null && mounted) {
      context.read<StyleCubit>().saveCustomizationStyle(
        result.name,
        result.prompt,
      );
    }
  }

  /// 确认删除自定义风格
  void _deleteCustomizationStyle(ReplyStyle style) async {
    final isDelete =
        await showDialog<bool?>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('确认删除风格${style.name}?'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('删除'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (isDelete && mounted) {
      context.read<StyleCubit>().deleteStyle(style.id);
    }
  }

  ExpansionPanelRadio _buildPanel(
    BuildContext context, {
    required int index,
    required ReplyStyle style,
  }) {
    return ExpansionPanelRadio(
      value: style.id,
      canTapOnHeader: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          leading: _buildStyleIcon(
            context,
            AppConstants.defaultReplyStyleIcons[style.id],
            isEnabled: isExpanded,
          ),
          title: Text(style.name),
          subtitle: Text(
            style.prompt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllers[index],
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: '请输入风格 Prompt...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            () {
              final actionChild = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _controllers[index].text = style.prompt;
                    },
                    child: const Text('重置'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      context.read<StyleCubit>().saveStylePrompt(
                        style.id,
                        _controllers[index].text,
                      );
                    },
                    child: const Text('保存'),
                  ),
                ],
              );

              if (style.isCustomization) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteCustomizationStyle(style);
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    ),
                    actionChild,
                  ],
                );
              }

              return actionChild;
            }(),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleIcon(
    BuildContext context,
    IconData? icon, {
    required bool isEnabled,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isEnabled
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        icon ?? Icons.dashboard_customize,
        color: isEnabled
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        size: 24,
      ),
    );
  }
}
