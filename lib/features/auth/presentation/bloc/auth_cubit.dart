import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';
import 'package:doctorbooking/features/auth/data/repositories/auth_repository.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_state.dart';
import 'package:doctorbooking/core/services/secure_storage_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  UserModel? _currentUser;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Check authentication status
  Future<void> _checkAuthStatus() async {
    emit(AuthLoading());
    
    // Check if user is logged in via secure storage
    final isLoggedIn = await SecureStorageService.isUserLoggedIn();
    
    if (isLoggedIn) {
      // Get user data from secure storage
      final userData = await SecureStorageService.getUserData();
      
      if (userData != null) {
        _currentUser = userData;
        emit(AuthAuthenticated(userData));
      } else {
        // Data corrupted, clear and show unauthenticated
        await SecureStorageService.clearUserData();
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Sign in with email and password
  Future<void> signInWithPhoneAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    // Clear all local storage before sign in
    await SecureStorageService.clearAll();
    
    final result = await _authRepository.signInWithEmailAndPassword(
      email:email,
      password: password,
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) async {
        _currentUser = user;
        log(user.toString());
        // Save user data to secure storage
        await SecureStorageService.saveUserData(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Send OTP foremail verification
  Future<void> sendOTP({required String email}) async {
    emit(AuthLoading());
    final result = await _authRepository.sendOTP(email:email);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthOTPSent(email)),
    );
  }

  // Verify OTP and sign in
  Future<void> verifyOTPAndSignIn({
    required String email,
    required String otp,
    String? password,
  }) async {
    emit(AuthLoading());
    
    // Clear all local storage before sign in
    await SecureStorageService.clearAll();
    
    final result = await _authRepository.verifyOTPAndSignIn(
      email:email,
      otp: otp,
      password: password ?? '',
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) async {
        _currentUser = user;
        // Save user data to secure storage
        await SecureStorageService.saveUserData(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Verify OTP for registration and create user account
  Future<void> verifyOTPForRegistration({
    required String email,
    required String otp,
    required String name,
    required String city,
    required String password,
    String? phone,
    String? dateOfBirth,
  }) async {
    emit(AuthLoading());
    
    // First verify OTP to establish session
    final otpResult = await _authRepository.verifyOTPForSession(
      email: email,
      otp: otp,
    );
    
    otpResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) async {
        // If OTP verification successful, create user account
        final result = await _authRepository.createUserAfterOTP(
          name: name,
          email: email,
          city: city,
          password: password,
          phone: phone,
          dateOfBirth: dateOfBirth,
        );
        
        result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) async {
            _currentUser = user;
            // Save user data to secure storage
            await SecureStorageService.saveUserData(user);
            emit(AuthAuthenticated(user));
          },
        );
      },
    );
  }

  // Create new user account after OTP verification
  Future<void> createUserAfterOTP({
    required String name,
    required String email,
    required String city,
    required String password,
    String? phone,
    String? dateOfBirth,
  }) async {
    emit(AuthLoading());
    
    // Clear all local storage before creating account
    await SecureStorageService.clearAll();
    
    final result = await _authRepository.createUserAfterOTP(
      name: name,
     email:email,
      city: city,
      password: password,
      phone: phone,
      dateOfBirth: dateOfBirth,
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) async {
        _currentUser = user;
        // Save user data to secure storage
        await SecureStorageService.saveUserData(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Reset password with OTP verification
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await _authRepository.resetPassword(
     email:email,
      otp: otp,
      newPassword: newPassword,
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        emit(AuthPasswordResetSuccess());
      },
    );
  }

  // Create new password without OTP (for verified sessions)
  Future<void> createNewPassword({
    required String email,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await _authRepository.createNewPassword(
      email: email,
      newPassword: newPassword,
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        emit(AuthPasswordResetSuccess());
      },
    );
  }

  // Create new user account
  Future<void> createUser({
    required String name,
    required String email,
    required String city,
    required String password,
    String? phone,
    String? dateOfBirth,
  }) async {
    emit(AuthLoading());
    
    // Clear all local storage before creating account
    await SecureStorageService.clearAll();
    
    final result = await _authRepository.createUser(
      name: name,
     email:email,
      city: city,
      password: password,
      phone: phone,
      dateOfBirth: dateOfBirth,
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) async {
        _currentUser = user;
        // Save user data to secure storage
        await SecureStorageService.saveUserData(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Sign out
  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await _authRepository.signOut();
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) async {
        _currentUser = null;
        // Clear user data from secure storage
        await SecureStorageService.clearUserData();
        emit(AuthUnauthenticated());
      },
    );
  }

  // Reset state to initial
  void resetState() {
    emit(AuthInitial());
  }

  // Clear error state
  void clearError() {
    if (state is AuthError) {
      emit(AuthInitial());
    }
  }
}
