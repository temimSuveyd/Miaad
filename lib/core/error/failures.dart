import 'package:equatable/equatable.dart';

// فشل أساسي
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// فشل الخادم
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// فشل الشبكة
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// فشل التخزين المؤقت
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// فشل قاعدة البيانات
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

// فشل المصادقة
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
