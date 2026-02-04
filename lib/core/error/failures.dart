import 'package:equatable/equatable.dart';

// فشل أساسي
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
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

// فشل بيانات الاعتماد غير صحيحة
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([super.message = 'بيانات الدخول غير صحيحة']);
}

// فشل المستخدم غير موجود
class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([super.message = 'المستخدم غير موجود']);
}

// فشل المستخدم موجود بالفعل
class UserAlreadyExistsFailure extends AuthFailure {
  const UserAlreadyExistsFailure([super.message = 'المستخدم موجود بالفعل']);
}

// فشل رمز التحقق
class OTPFailure extends AuthFailure {
  const OTPFailure(super.message);
}

// فشل انتهاء صلاحية رمز التحقق
class OTPExpiredFailure extends AuthFailure {
  const OTPExpiredFailure([super.message = 'رمز التحقق منتهي الصلاحية']);
}

// فشل انتهاء صلاحية الجلسة
class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([super.message = 'انتهت صلاحية الجلسة']);
}

// فشل الوصول مرفوض
class PermissionDeniedFailure extends AuthFailure {
  const PermissionDeniedFailure([super.message = 'الوصول مرفوض']);
}

// فشل التحقق من البيانات
class ValidationFailure extends AuthFailure {
  final String field;
  
  const ValidationFailure(this.field, super.message);
  
  @override
  List<Object?> get props => [message, field];
  
  @override
  String get message => 'خطأ في التحقق: $field - ${super.message}';
}

// فشل انتهاء المهلة
class TimeoutFailure extends AuthFailure {
  const TimeoutFailure([super.message = 'انتهت مهلة الاتصال']);
}

// فشل تجاوز عدد المحاولات
class RateLimitFailure extends AuthFailure {
  final int? retryAfter;
  
  const RateLimitFailure(super.message, [this.retryAfter]);
  
  @override
  List<Object?> get props => [message, retryAfter];
  
  @override
  String get message => 'تجاوز عدد المحاولات: ${super.message}${retryAfter != null ? ' (أعد المحاولة بعد $retryAfter ثانية)' : ''}';
}

// فشل غير معروف
class UnknownFailure extends AuthFailure {
  const UnknownFailure(super.message);
}
