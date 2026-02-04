import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/core/widgets/bottom_sheets/city_selector_bottom_sheet.dart';
import 'package:doctorbooking/features/shared/widgets/custom_button.dart';
import 'package:doctorbooking/features/shared/widgets/custom_text_field.dart';
import 'package:doctorbooking/features/auth/presentation/widgets/email_input_widget.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:doctorbooking/features/auth/presentation/bloc/auth_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authCubit = context.read<AuthCubit>();
    
    // First send OTP to verify phone number
    await authCubit.sendOTP(email: _emailController.text.trim());
  }

  void _showCitySelector() async {
    final selectedCity = await CitySelectorBottomSheet.show(
      context: context,
      selectedCity: _cityController.text.isNotEmpty ? _cityController.text : null,
    );

    if (selectedCity != null) {
      _cityController.text = selectedCity.nameAr;
    }
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
              // Navigate to OTP page with registration data
              Get.toNamed(
                AppRoutes.otp,
                arguments: {
                  'phone': _emailController.text.trim(),
                  'password': _passwordController.text,
                  'name': _nameController.text.trim(),
                  'city': _cityController.text.trim(),
                  'isRegistration': true, // Flag to indicate this is registration
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
                      const SizedBox(height: 40),
                      
                      // Logo and Title
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
                                Iconsax.user_add,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'أدخل بياناتك لإنشاء حساب جديد',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Name Field
                      CustomTextField(
                        controller: _nameController,
                        label: 'الاسم الكامل',
                        hintText: 'أدخل اسمك الكامل',
                        prefixIcon: Iconsax.user,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الاسم الكامل';
                          }
                          if (value.trim().length < 3) {
                            return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Phone Field
                      EmailInputWidget(
                        controller: _emailController,
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
                      
                      // City Field
                      GestureDetector(
                        onTap: _showCitySelector,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _cityController,
                            label: 'المدينة',
                            hintText: 'اختر مدينتك',
                            prefixIcon: Iconsax.location,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى اختيار المدينة';
                              }
                              return null;
                            },
                          ),
                        ),
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
                      
                      const SizedBox(height: 20),
                      
                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'تأكيد كلمة المرور',
                        hintText: '••••••••',
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Iconsax.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Iconsax.eye : Iconsax.eye_slash,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى تأكيد كلمة المرور';
                          }
                          if (value != _passwordController.text) {
                            return 'كلمات المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Register Button
                      CustomButton(
                        text: 'إنشاء حساب',
                        onPressed: _register,
                        isLoading: state is AuthLoading,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.login);
                              },
                              child: Text(
                                'تسجيل الدخول',
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
