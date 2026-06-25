import 'dart:io';

import 'package:ai_keyboard/channel/only_ios_event_channel.g.dart';
import 'package:ai_keyboard/config/routes/app_router.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/utils/shares_local_data/shares_local_data.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 功能模块数据模型
///
/// [router] 为 null 表示该功能尚未实现。
typedef _ModuleItem = ({
  IconData icon,
  String title,
  String desc,
  String? router,
});

/// Home 页面
///
/// 纯静态功能导航页，无业务逻辑，不使用 BLoC。
///
/// 启动时会检查：
/// 1. 是否首次打开 App；
/// 2. iOS 上键盘扩展是否已启用。
///
/// 任一条件不满足就自动进入帮助页。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<_ModuleItem> _modules = <_ModuleItem>[
    (
      icon: Icons.chat_bubble_outline_rounded,
      title: '模拟聊天',
      desc: '模拟聊天，体验AI回复',
      router: Routes.chat,
    ),
    (
      icon: Icons.settings,
      title: 'AI 配置',
      desc: '设置AI Key与模型参数',
      router: Routes.setting,
    ),
    (icon: Icons.edit, title: '风格编辑', desc: '自定义回复风格', router: Routes.style),
    (
      icon: Icons.info_outline,
      title: '使用帮助',
      desc: '查看引导教程',
      router: Routes.helper,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndShowHelperIfNeeded();
  }

  /// 检查是否需要进入帮助页。
  ///
  /// 首次启动或者 iOS 上键盘扩展没启用时，都自动跳转到帮助页。
  /// 如果是首次启动，跳转后把 first_open 标记为 false。
  Future<void> _checkAndShowHelperIfNeeded() async {
    final localData = sl.get<SharesLocalData>();
    final isFirstOpen =
        await localData.getBool(
          AppConstants.dataKeyFirstOpen,
          defaultValue: true,
        ) ??
        true;

    var isKeyboardEnabled = true;
    if (Platform.isIOS) {
      try {
        isKeyboardEnabled = await IosGroupAppEventChannel()
            .isKeyboardExtensionEnabled();
      } catch (e) {
        debugPrint('[Home] 检测键盘扩展失败: $e');
      }
    }

    debugPrint(
      '[Home] 启动检查 - isFirstOpen=$isFirstOpen, isKeyboardEnabled=$isKeyboardEnabled',
    );

    final shouldShowHelper =
        isFirstOpen || (Platform.isIOS && !isKeyboardEnabled);
    if (!shouldShowHelper) return;

    if (mounted) {
      context.push(Routes.helper);
    }

    if (isFirstOpen) {
      await localData.putBool(AppConstants.dataKeyFirstOpen, false);
      debugPrint('[Home] 已标记为非首次启动');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverAppBar(
              title: Text(AppConstants.appName),
              centerTitle: false,
            ),
          ),
          // 功能模块入口
          SliverPadding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            sliver: SliverGrid.builder(
              itemCount: _modules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                childAspectRatio: 4 / 5,
              ),
              itemBuilder: (context, index) {
                final item = _modules[index];
                final isEnabled = item.router != null;

                return Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: isEnabled
                        ? () => context.push(item.router!)
                        : () => _showDevelopingToast(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFunctionalIcon(
                            context,
                            item.icon,
                            isEnabled: isEnabled,
                          ),
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            item.desc,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: isEnabled
                                      ? null
                                      : colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // SliverToBoxAdapter(
          //   child: FilledButton(
          //     onPressed: () {
          //       sl.get<ConfigurationRepository>().clearConfiguration();
          //     },
          //     child: Text('清空数据'),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 构建功能模块图标
  Widget _buildFunctionalIcon(
    BuildContext context,
    IconData icon, {
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
        icon,
        color: isEnabled
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        size: 24,
      ),
    );
  }

  /// 提示功能开发中
  void _showDevelopingToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('功能开发中，敬请期待'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
