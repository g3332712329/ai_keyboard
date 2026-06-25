import 'package:ai_keyboard/config/routes/app_router.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/utils/shares_local_data/shares_local_data.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 应用引导页
///
/// 展示产品核心卖点，并提供「开始使用」与「跳过」两个入口。
class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.chat_outlined,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI 回复助手',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Text(
              '让每一次回复都恰到好处',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTraitsView(
                  colorScheme,
                  Icons.electric_bolt_rounded,
                  '极速',
                ),
                _buildTraitsView(colorScheme, Icons.smart_toy_outlined, 'Ai驱动'),
                _buildTraitsView(colorScheme, Icons.privacy_tip_outlined, '隐私'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () async {
                  await _markHelperAsShown();
                  if (context.mounted) {
                    context.pushReplacement(Routes.helperSetting);
                  }
                },
                child: const Text('开始使用'),
              ),
              TextButton(
                onPressed: () async {
                  await _markHelperAsShown();
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text('已有配置跳过'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 把 first_open 标记为 false，确保下次启动不再自动弹帮助页。
  ///
  /// 首页在跳转前通常已经标记过了，这里再标记一次作为兜底。
  Future<void> _markHelperAsShown() async {
    try {
      final localData = sl.get<SharesLocalData>();
      await localData.putBool(AppConstants.dataKeyFirstOpen, false);
      debugPrint('[Helper] 已标记帮助页已展示');
    } catch (e) {
      debugPrint('[Helper] 标记帮助页状态时出错: $e');
    }
  }

  Widget _buildTraitsView(ColorScheme colorScheme, IconData icon, String text) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [Icon(icon), const SizedBox(height: 8), Text(text)],
          ),
        ),
      ),
    );
  }
}
