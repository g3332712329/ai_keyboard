import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/widgets/bloc_effect_listener.dart';
import 'package:ai_keyboard/features/setting/setting_cubit.dart';
import 'package:ai_keyboard/features/setting/widget/api_key_dialog.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingCubit>(
      create: (context) {
        return SettingCubit(sl.get<ConfigurationRepository>())..loadConfig();
      },
      child: const BlocEffectListener<SettingCubit, SettingState>(
        child: _Page(),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(value.message)));
            },
          );
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: AppConstants.defaultAnimationDuration,
            child: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (platform, platforms, preferences, replyStyles) {
                final autoSendPref = preferences.firstWhere(
                  (p) => p.key == AppConstants.appPreferenceKeyAutoSend,
                  orElse: () => const AppPreference(
                    key: AppConstants.appPreferenceKeyAutoSend,
                    name: '自动发送',
                    isOpen: false,
                  ),
                );
                return CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text('AI 配置'),
                      centerTitle: false,
                      floating: true,
                    ),
                    _buildGroupTitle('API 设置'),
                    _buildPopupItemContent([
                      _GroupPopupItem(
                        icon: Icons.auto_awesome_rounded,
                        title: 'AI 平台 ${platform.name}',
                        subTitle: platform.baseUrl,
                        onTap: () => _onTapPlatform(context, platforms),
                      ),
                      _GroupPopupItem(
                        icon: Icons.key_rounded,
                        title: 'API Key',
                        subTitle: platform.apiKey.isNotEmpty
                            ? '${platform.apiKey.substring(0, platform.apiKey.length > 8 ? 8 : platform.apiKey.length)}****'
                            : '未配置',
                        onTap: () => _onTapApiKey(context, platform.apiKey),
                      ),
                      _GroupPopupItem(
                        icon: Icons.layers,
                        title: '模型选择',
                        subTitle: platform.selectedModel.isNotEmpty
                            ? platform.selectedModel
                            : '未选择',
                        onTap:
                            platform.models.isNotEmpty &&
                                platform.apiKey.isNotEmpty
                            ? () => _onTapModel(context, platform)
                            : null,
                      ),
                    ]),
                    _buildGroupTitle('偏好设置'),
                    _buildSwitchItemContent([
                      _GroupSwitchItem(
                        icon: Icons.send_rounded,
                        title: '自动发送',
                        isSwitch: autoSendPref.isOpen,
                        onSwitch: (value) {
                          context.read<SettingCubit>().updatePreference(
                            AppConstants.appPreferenceKeyAutoSend,
                            value,
                          );
                        },
                      ),
                    ]),
                  ],
                );
              },
              error: (message) => Center(child: Text('出错了：$message')),
            ),
          );
        },
      ),
    );
  }

  /// 修改 AI 平台
  void _onTapPlatform(BuildContext context, List<AiPlatform> platforms) async {
    final platform = await _showPlatformChoiceDialog(context, platforms);
    if (platform == null || !context.mounted) return;
    context.read<SettingCubit>().changePlatform(platform);
  }

  /// 修改平台 API Key
  void _onTapApiKey(BuildContext context, String currentApiKey) async {
    final newApiKey = await showDialog<String>(
      context: context,
      builder: (context) => ApiKeyDialog(currentApiKey: currentApiKey),
    );
    if (newApiKey == null || newApiKey.isEmpty) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    context.read<SettingCubit>().savePlatformApiKey(newApiKey);
  }

  /// 选择平台模型
  void _onTapModel(BuildContext context, AiPlatform platform) async {
    var selectModel = await _showModelChoiceDialog(
      context,
      platform.selectedModel,
      platform.models,
    );
    if (selectModel == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    context.read<SettingCubit>().savePlatformModel(selectModel);
  }

  /// 构建分组配置标题
  Widget _buildGroupTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
        child: Text(title, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  /// 构建弹窗项目
  Widget _buildPopupItemContent(List<_GroupPopupItem> items) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        child: Card(
          child: Column(
            children: items.asMap().entries.expand((entry) {
              final widgets = <Widget>[
                ListTile(
                  key: ValueKey(entry.value.hashCode),
                  leading: Icon(entry.value.icon),
                  title: Text(entry.value.title),
                  subtitle: Text(entry.value.subTitle),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  enabled: entry.value.onTap != null,
                  onTap: entry.value.onTap,
                ),
              ];
              if (entry.key < items.length - 1) {
                widgets.add(const Divider(height: 1));
              }
              return widgets;
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 构建选择器项目
  Widget _buildSwitchItemContent(List<_GroupSwitchItem> items) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
        child: Card(
          child: Column(
            children: items.asMap().entries.expand((entry) {
              final item = entry.value;
              final widgets = <Widget>[
                ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  trailing: Switch(
                    value: item.isSwitch,
                    onChanged: item.onSwitch,
                  ),
                ),
              ];
              if (entry.key < items.length - 1) {
                widgets.add(const Divider(height: 1));
              }
              return widgets;
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<AiPlatform?> _showPlatformChoiceDialog(
    BuildContext context,
    List<AiPlatform> platforms,
  ) async {
    final currentPlatform = platforms.firstWhere((e) => e.enable);
    return showDialog<AiPlatform>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择 AI 平台'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: platforms.map((e) {
              return RadioListTile<AiPlatform>(
                title: Text(e.name),
                value: e,
                groupValue: currentPlatform,
                onChanged: (value) {
                  if (value != null) {
                    context.pop(value);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<String?> _showModelChoiceDialog(
    BuildContext context,
    String currentModels,
    List<String> models,
  ) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('选择模型'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              children: models.map((e) {
                return RadioListTile(
                  title: Text(e),
                  value: e,
                  groupValue: currentModels,
                  onChanged: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _GroupPopupItem {
  final IconData icon;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  _GroupPopupItem({
    required this.icon,
    required this.title,
    required this.subTitle,
    this.onTap,
  });
}

class _GroupSwitchItem {
  final IconData icon;
  final String title;
  final bool isSwitch;
  final ValueChanged<bool> onSwitch;

  _GroupSwitchItem({
    required this.icon,
    required this.title,
    this.isSwitch = false,
    required this.onSwitch,
  });
}
