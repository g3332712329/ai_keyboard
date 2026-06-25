import 'package:ai_keyboard/config/routes/app_router.dart';
import 'package:ai_keyboard/features/helper/helper_setting_step_resolver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 键盘启用引导页。
///
/// 展示当前平台下启用键盘所需的步骤。步骤内容通过 [SetupStepManager]
/// 根据平台/版本/厂商动态解析，UI 只负责渲染，不耦合具体业务文案。
class HelperSettingPage extends StatelessWidget {
  const HelperSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<SetupSystemInfo>(
          future: SetupSystemInfo.fromDeviceInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomScrollView(
                slivers: [
                  SliverAppBar(title: Text('启用AI键盘')),
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            final info = snapshot.data ?? SetupSystemInfo.fromPlatform();
            final steps = defaultSetupStepManager.resolve(info);

            return CustomScrollView(
              slivers: [
                const SliverAppBar(title: Text('启用AI键盘')),
                ...steps.map(
                  (step) => SliverToBoxAdapter(child: _StepsCard(step: step)),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilledButton(
                      onPressed: () {
                        context.pushReplacement(Routes.helperTips);
                      },
                      child: const Text('下一步'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  final SetupStep step;

  const _StepsCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTag(colorScheme),
            _buildIcon(colorScheme),
            Text(
              step.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Text(
              step.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            _buildInstructionBox(colorScheme),
            if (step.action != null && step.actionTitle != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final message = await step.action!.call();
                    if (context.mounted && message != null) {
                      _showMessage(context, message);
                    }
                  },
                  child: Text(step.actionTitle!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
          ],
        ),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: const Color(0xFF1565C0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildTag(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        step.tag,
        style: TextStyle(color: colorScheme.onPrimary, fontSize: 12),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Icon(step.icon, color: colorScheme.onPrimary),
    );
  }

  Widget _buildInstructionBox(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        step.instruction,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
