import 'package:equatable/equatable.dart';


/// 业务异常基类
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// 服务器异常
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// 网络连接异常
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = '网络连接异常，请检查网络设置'});
}

/// 缓存异常
class CacheFailure extends Failure {
  const CacheFailure({super.message = '本地缓存读取失败'});
}

/// 输入验证异常
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// 未授权异常
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = '登录已过期，请重新登录'});
}

/// 未知异常
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = '发生未知错误'});
}
