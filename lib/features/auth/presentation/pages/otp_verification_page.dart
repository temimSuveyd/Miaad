import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/features/shared/widgets/custom_button.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_state.dart';
import 'package:uni_size/uni_size.dart';

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _OTPVerificationForm(),
    );
  }
}

class _OTPVerificationForm extends StatefulWidget {
  const _OTPVerificationForm();

  @override
  State<_OTPVerificationForm> createState() => _OTPVerificationFormState();
}

class _OTPVerificationFormState extends State<_OTPVerificationForm> {
  String _otp = '';
  
  String _email = '';
  String _password = '';
  String _name = '';
  String _city = '';
  bool _isRegistration = false;
  bool _isPasswordReset = false;

  @override
  void initState() {
    super.initState();
    // Get arguments from previous page
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _email = arguments['phone'] ?? '';
      _password = arguments['password'] ?? '';
      _name = arguments['name'] ?? '';
      _city = arguments['city'] ?? '';
      _isRegistration = arguments['isRegistration'] ?? false;
      _isPasswordReset = arguments['isPasswordReset'] ?? false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> _verifyOTP() async {
    if (_otp.length != 6) {
      SnackbarService.showError(
        context: context,
        title: 'خطأ',
        message: 'يرجى إدخال رمز التحقق المكون من 6 أرقام',
      );
      return;
    }

    final authCubit = context.read<AuthCubit>();
    
    if (_isRegistration) {
      // This is registration - first verify OTP to establish session, then create account
      await authCubit.verifyOTPForRegistration(
        email: _email,
        otp: _otp,
        name: _name,
        city: _city,
        password: _password,
      );
    } else if (_isPasswordReset) {
      // This is password reset - navigate to create new password page
      Get.toNamed(
        AppRoutes.createNewPassword,
        arguments: {
          'email': _email,
          'otp': _otp,
        },
      );
    } else {
      // This is login - verify OTP and sign in
      await authCubit.verifyOTPAndSignIn(
        email: _email,
        otp: _otp,
        password: _password,
      );
    }
  }

  Future<void> _resendOTP() async {
    final authCubit = context.read<AuthCubit>();
    
    await authCubit.sendOTP(email: _email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Get.offAllNamed(AppRoutes.navigationPage);
            } else if (state is AuthError) {
              SnackbarService.showError(
                context: context,
                title: 'خطأ',
                message: state.message,
              );
            } else if (state is AuthOTPSent) {
              SnackbarService.showSuccess(
                context: context,
                title: 'نجح',
                message: 'تم إرسال رمز التحقق مجدداً',
              );
            } else if (state is AuthPasswordResetSuccess) {
              SnackbarService.showSuccess(
                context: context,
                title: 'نجح',
                message: 'تم تحديث كلمة المرور بنجاح',
              );
              Get.offAllNamed(AppRoutes.login);
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Iconsax.message,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'تحقق من الرمز',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isPasswordReset 
                                ? 'تحقق من الرمز لإعادة تعيين كلمة المرور'
                                : _isRegistration 
                                    ? 'أدخل رمز التحقق المكون من 6 أرقام لإكمال التسجيل'
                                    : 'أدخل رمز التحقق المكون من 6 أرقام الذي تم إرساله إلى',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // OTP Input Field
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: OtpTextField(
                          
                          numberOfFields: 6,
                          // borderColor: AppTheme.textSecondary.withValues(alpha: 0.3),
                          fillColor: AppTheme.dividerColor,
                          filled: true,
                          focusedBorderColor: AppTheme.primaryColor,
                          showFieldAsBox: true,
                          // borderWidth: 2.0,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 60.dp,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          contentPadding: EdgeInsets.all(0),
                          onCodeChanged: (String code) {
                            if (code.length == 6) {
                              _otp = code;
                              _verifyOTP();
                            }
                          },
                          onSubmit: (String verificationCode) {
                            _otp = verificationCode;
                            _verifyOTP();
                          }, // end onSubmit
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Verify Button
                    CustomButton(
                      text: _isPasswordReset 
                          ? 'إعادة تعيين كلمة المرور' 
                          : _isRegistration 
                              ? 'إنشاء الحساب' 
                              : 'تحقق',
                      onPressed: _verifyOTP,
                      isLoading: state is AuthLoading,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Resend OTP
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'لم تستلم الرمز؟',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: _resendOTP,
                            child: Text(
                              'إعادة الإرسال',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Back to Login
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Iconsax.arrow_right,
                          color: AppTheme.textSecondary,
                          size: 16,
                        ),
                        label: Text(
                          _isPasswordReset 
                              ? 'العودة لإعادة تعيين كلمة المرور'
                              : _isRegistration 
                                  ? 'العودة للتسجيل'
                                  : 'العودة لتسجيل الدخول',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
