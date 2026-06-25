import 'package:flutter/material.dart';

import 'config/routes/app_router.dart';

/// 应用根组件
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI 回复助手',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
