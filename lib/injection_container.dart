import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/repository/configuration_repository.dart';
import 'core/repository/local_configuration_repository.dart';
import 'core/utils/shares_local_data/mmkv_shares_local_data.dart';
import 'core/utils/shares_local_data/shares_local_data.dart';

/// 依赖注入容器
final sl = GetIt.instance;

/// 初始化依赖注入
Future<void> initDependencies() async {
  // HTTP 客户端
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  // 本地键值存储（MMKV）
  sl.registerSingletonAsync<SharesLocalData>(() async {
    final storage = MmkvSharesLocalData();
    await storage.init();
    return storage;
  });

  // 配置仓库（本地存储）
  // 后续如需切换为云端存储，替换为 RemoteConfigurationRepository 即可
  sl.registerSingletonAsync<ConfigurationRepository>(
    () async => LocalConfigurationRepository(
      localData: await sl.getAsync<SharesLocalData>(),
    ),
  );

  // 等待所有异步单例初始化完成，这样 runApp 之后就可以直接用 sl.get<T>()。
  await sl.allReady();

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
}
