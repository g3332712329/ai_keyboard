import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelperTipsPage extends StatelessWidget {
  const HelperTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('三步上手')),

          const SliverPadding(padding: .all(10)),

          const SliverToBoxAdapter(
            child: _StepsLearnView(
              stepsIndex: 1,
              iconData: Icons.paste_rounded,
              title: '粘贴对话内容',
              subTitle: '复制对方的消息，粘贴到键盘面板中',
            ),
          ),
          const SliverToBoxAdapter(
            child: _StepsLearnView(
              stepsIndex: 2,
              iconData: Icons.style_outlined,
              title: '选择回复风格',
              subTitle: '根据场景选择风格。',
            ),
          ),
          const SliverToBoxAdapter(
            child: _StepsLearnView(
              stepsIndex: 3,
              iconData: Icons.send_outlined,
              title: '一键生成并发送',
              subTitle: 'AI 生成回复后自动注入输入框，直接点击发送即可。',
              hideDivider: true,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {
              context.pop();
            },
            child: Text('进入主页'),
          ),
        ),
      ),
    );
  }
}

class _StepsLearnView extends StatelessWidget {
  final int stepsIndex;
  final IconData iconData;
  final String title;
  final String subTitle;
  final bool hideDivider;

  const _StepsLearnView({
    required this.stepsIndex,
    required this.iconData,
    required this.title,
    required this.subTitle,
    this.hideDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Text('$stepsIndex'),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(
                  iconData,
                  size: 28,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 52,
                      child: Align(
                        alignment: .centerStart,
                        child: Text(title, style: theme.textTheme.titleMedium),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!hideDivider) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
