import 'dart:developer';

import 'package:doctorbooking/core/error/failures.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendOTP({required String email});

  Future<UserModel> verifyOTPAndSignIn({
    required String email,
    required String otp,
    required String password,
  });

  Future<UserModel> createUserAfterOTP({
    required String name,
    required String email,
    required String city,
    required String password,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String city,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _supabaseClient;

  AuthDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password using Supabase Auth
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const InvalidCredentialsFailure('فشل تسجيل الدخول');
      }

      // Get user data from the users table
      try {
        final userData = await _supabaseClient
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

        return UserModel.fromJson(userData);
      } catch (e) {
        throw const UserNotFoundFailure('بيانات المستخدم غير موجودة');
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw const InvalidCredentialsFailure(
          'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      } else if (e.message.contains('Too many requests')) {
        throw const RateLimitFailure(
          'محاولات تسجيل دخول كثيرة، يرجى المحاولة لاحقاً',
        );
      } else {
        log(e.message);
        throw AuthFailure('خطأ في المصادقة: ${e.message}');
      }
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<void> sendOTP({required String email}) async {
    try {
      // Send OTP using Supabase Auth with email
      await _supabaseClient.auth.signInWithOtp(email: email);
    } on AuthException catch (e) {
      log(e.message);
      if (e.message.contains('Too many requests')) {
        throw const RateLimitFailure(
          'محاولات إرسال كثيرة، يرجى المحاولة لاحقاً',
        );
      } else if (e.message.contains('Invalid email')) {
        throw ValidationFailure('email', 'البريد الإلكتروني غير صالح');
      } else {
        throw OTPFailure('فشل إرسال رمز التحقق: ${e.message}');
      }
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyOTPAndSignIn({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      // Verify OTP and sign in
      final response = await _supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw const InvalidCredentialsFailure('فشل التحقق من الرمز');
      }

      // Get user data from the users table
      try {
        final userData = await _supabaseClient
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

        return UserModel.fromJson(userData);
      } catch (e) {
        throw const UserNotFoundFailure('بيانات المستخدم غير موجودة');
      }
    } on AuthException catch (e) {
      log(e.message);
      if (e.message.contains('OTP has expired')) {
        throw const OTPExpiredFailure();
      } else if (e.message.contains('Invalid OTP')) {
        throw const OTPFailure('رمز التحقق غير صحيح');
      } else {
        throw OTPFailure('خطأ في التحقق من الرمز: ${e.message}');
      }
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> createUserAfterOTP({
    required String name,
    required String email,
    required String city,
    required String password,
  }) async {
    try {
      // Validate input
      if (name.trim().isEmpty) {
        throw const ValidationFailure('name', 'الاسم مطلوب');
      }
      if (email.trim().isEmpty) {
        throw const ValidationFailure('email', 'البريد الإلكتروني مطلوب');
      }
      if (city.trim().isEmpty) {
        throw const ValidationFailure('city', 'المدينة مطلوبة');
      }
      if (password.length < 6) {
        throw const ValidationFailure(
          'password',
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // Create user with email and password in Supabase Auth
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthFailure('فشل إنشاء المستخدم');
      }

      // Create user record in the users table
      final userData = {
        'id': response.user!.id,
        'full_name': name,
        'email': email,
        'city': city,
        'created_at': DateTime.now().toIso8601String(),
        'role': 'patient',
        'phone': '',
      };

      try {
        await _supabaseClient.from('users').insert(userData);
      } catch (e) {
        // If user creation in database fails, delete the auth user
        await _supabaseClient.auth.admin.deleteUser(response.user!.id);
        throw const UserAlreadyExistsFailure('المستخدم موجود بالفعل');
      }

      // Get the created user data
      try {
        final createdUser = await _supabaseClient
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

        return UserModel.fromJson(createdUser);
      } catch (e) {
        throw const UserNotFoundFailure('فشل الحصول على بيانات المستخدم');
      }
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        throw const UserAlreadyExistsFailure('المستخدم موجود بالفعل');
      } else if (e.message.contains('Invalid email')) {
        throw ValidationFailure('email', 'البريد الإلكتروني غير صالح');
      } else {
        log(e.message);
        throw AuthFailure('خطأ في المصادقة: ${e.message}');
      }
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String city,
    required String password,
  }) async {
    // This method is deprecated - use createUserAfterOTP instead
    throw const AuthFailure('هذه الطريقة لم تعد مدعومة. يرجى استخدام التحقق من OTP أولاً');
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // Validate input
      if (email.trim().isEmpty) {
        throw const ValidationFailure('email', 'البريد الإلكتروني مطلوب');
      }
      if (otp.trim().isEmpty) {
        throw const ValidationFailure('otp', 'رمز التحقق مطلوب');
      }
      if (newPassword.length < 6) {
        throw const ValidationFailure(
          'password',
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // First verify the OTP
      final response = await _supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw const InvalidCredentialsFailure('رمز التحقق غير صحيح');
      }

      // Update the user's password
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );

    } on AuthException catch (e) {
      log(e.message);
      if (e.message.contains('OTP has expired')) {
        throw const OTPExpiredFailure();
      } else if (e.message.contains('Invalid OTP')) {
        throw const OTPFailure('رمز التحقق غير صحيح');
      } else if (e.message.contains('Too many requests')) {
        throw const RateLimitFailure('محاولات كثيرة، يرجى المحاولة لاحقاً');
      } else {
        throw AuthFailure('خطأ في إعادة تعيين كلمة المرور: ${e.message}');
      }
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw UnknownFailure('خطأ غير معروف: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      // Get user data from the users table
      try {
        final userData = await _supabaseClient
            .from('users')
            .select()
            .eq('id', currentUser.id)
            .single();

        return UserModel.fromJson(userData);
      } catch (e) {
        // User exists in auth but not in database
        return null;
      }
    } on AuthException catch (e) {
      if (e.message.contains('session has expired')) {
        throw const SessionExpiredFailure();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
