import 'package:doctorbooking/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/shared/widgets/custom_button.dart';
import 'package:doctorbooking/features/shared/widgets/custom_text_field.dart';
import 'package:doctorbooking/features/auth/presentation/widgets/email_input_widget.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authCubit = context.read<AuthCubit>();
    
    await authCubit.signInWithPhoneAndPassword(
      email: _phoneController.text.trim(),
      password: _passwordController.text,
    );
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
              Get.toNamed(
                AppRoutes.otp,
                arguments: {
                  'phone': _phoneController.text.trim(),
                  'password': _passwordController.text,
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
                      
                      // Logo and Title
                      Center(
                        child: Column(
                          children: [
                            // Container(
                            //   width: 70,
                            //   height: 70,
                            //   decoration: BoxDecoration(
                            //     image:DecorationImage(image: AssetImage(Constants.logoAsset),fit: BoxFit.cover),
                            //     // color: AppTheme.primaryColor.withOpacity(0.1),
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            // ),
                            // const SizedBox(height: 5),

                            //                             Text(
                            //   'Miad' ' App',
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.normal,
                            //     color: AppTheme.textPrimary,
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'أدخل رقم الهاتف وكلمة المرور للمتابعة',
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
                      
                      // Phone Field
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
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        hintText: '••••••••',
                        obscureText: _obscurePassword,
                        prefixIcon: Iconsax.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.forgotPassword);
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign In Button
                      CustomButton(
                        text: 'تسجيل الدخول',
                        onPressed: _signIn,
                        isLoading: state is AuthLoading,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign Up Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.register);
                              },
                              child: Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
