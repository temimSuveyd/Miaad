import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/shared/widgets/custom_button.dart';
import 'package:doctorbooking/features/auth/presentation/widgets/email_input_widget.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authCubit = context.read<AuthCubit>();
    
    // Send OTP for password reset
    await authCubit.sendOTP(email: _phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              SnackbarService.showError(
                context: context,
                title: 'خطأ',
                message: state.message,
              );
            } else if (state is AuthOTPSent) {
              // Navigate to OTP page for password reset
              Get.toNamed(
                AppRoutes.otp,
                arguments: {
                  'phone': _phoneController.text.trim(),
                  'isPasswordReset': true, // Flag to indicate this is password reset
                },
              );
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
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
                                Iconsax.lock,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'نسيت كلمة المرور',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Phone Input
                      EmailInputWidget(
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          // Basic email validation
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Send OTP Button
                      CustomButton(
                        text: 'إرسال رمز التحقق',
                        onPressed: _sendOTP,
                        isLoading: state is AuthLoading,
                      ),
                      
                      const SizedBox(height: 30),
                      
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
                            'العودة لتسجيل الدخول',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
