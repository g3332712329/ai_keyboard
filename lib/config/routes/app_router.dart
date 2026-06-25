import 'package:ai_keyboard/features/chat/chat_page.dart';
import 'package:ai_keyboard/features/helper/helper_page.dart';
import 'package:ai_keyboard/features/helper/helper_setting_page.dart';
import 'package:ai_keyboard/features/helper/helper_tips_page.dart';
import 'package:ai_keyboard/features/home/view.dart';
import 'package:ai_keyboard/features/setting/setting_page.dart';
import 'package:ai_keyboard/features/style/style_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 路由路径常量
abstract class Routes {
  static const String home = '/';

  static const String setting = '/setting';

  static const String style = '/style';

  static const String chat = '/chat';

  static const String helper = '/helper';

  static const String helperSetting = '/helperSetting';

  static const String helperTips = "/helperTips";
}

/// 应用路由配置（使用 go_router）
abstract class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: Routes.setting,
        name: 'setting',
        builder: (context, state) => const SettingPage(),
      ),

      GoRoute(
        path: Routes.style,
        name: 'style',
        builder: (context, state) => const StylePage(),
      ),
      GoRoute(
        path: Routes.chat,
        name: 'chat',
        builder: (context, state) => const ChatPage(),
      ),

      GoRoute(
        path: Routes.helper,
        name: 'helper',
        builder: (context, state) => const HelperPage(),
      ),
      GoRoute(
        path: Routes.helperSetting,
        name: 'helperSetting',
        builder: (context, state) => const HelperSettingPage(),
      ),
      GoRoute(
        path: Routes.helperTips,
        name: 'helperTips',
        builder: (context, state) => const HelperTipsPage(),
      ),
    ],
  );
}
