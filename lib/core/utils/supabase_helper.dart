import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../error/exceptions.dart' hide AuthException;

// مساعد Supabase - معالجة الأخطاء والعمليات الشائعة
class SupabaseHelper {
  static SupabaseClient get client => SupabaseConfig.client;

  // معالجة أخطاء Supabase
  static Exception handleError(Object error) {
    if (error is Exception &&
        (error is DatabaseException ||
            error is NetworkException ||
            error is AuthException ||
            error is CacheException ||
            error is ServerException)) {
      return error;
    }

    if (error is PostgrestException) {
      return DatabaseException('خطأ في قاعدة البيانات: ${error.message}');
    } else if (error is AuthException) {
      return AuthException('خطأ في المصادقة: ${error.message}');
    } else if (error is StorageException) {
      return ServerException('خطأ في التخزين: ${error.message}');
    } else {
      return ServerException('خطأ غير متوقع: $error');
    }
  }

  // تنفيذ عملية مع معالجة الأخطاء
  static Future<T> executeQuery<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      throw handleError(e);
    }
  }

  // الحصول على المستخدم الحالي
  static String? getCurrentUserId() {
    return client.auth.currentUser?.id;
  }

  // التحقق من تسجيل الدخول
  static bool isAuthenticated() {
    return client.auth.currentUser != null;
  }
}
