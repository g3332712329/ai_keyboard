import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/utils/shares_local_data/shares_local_data.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖注入
  await initDependencies();

  await initData();

  runApp(const App());
}

Future<void> initData() async {
  final localData = sl.get<SharesLocalData>();
  var isFirstOpen =
      await localData.getBool(
        AppConstants.dataKeyFirstOpen,
        defaultValue: true,
      ) ??
      true;
  if (isFirstOpen) {
    // 首次启动时把默认配置写入本地存储。

    // 写入AI角色提示词, ios端和Android端共用一套AI角色提示词
    await localData.putString(
      AppConstants.dataKeyAiRolePrompt,
      AppConstants.defaultAiRolePrompt,
    );

    // first_open 标志不在此处清除，留给帮助页或首页检查后再标记，
    // 确保用户一定能看到首次引导。
    debugPrint('[Init] 首次启动，写入默认配置');
    final configRepository = sl.get<ConfigurationRepository>();
    await configRepository.updateConfiguration((current) => current);
  }
}
