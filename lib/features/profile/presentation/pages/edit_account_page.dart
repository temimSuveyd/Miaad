import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/bottom_sheets/city_selector_bottom_sheet.dart';
import '../../../../core/data/syrian_cities.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../cubit/profile_cubit.dart';

class EditAccountPage extends StatelessWidget {
  const EditAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const EditAccountView(),
    );
  }
}

class EditAccountView extends StatefulWidget {
  const EditAccountView({super.key});

  @override
  State<EditAccountView> createState() => _EditAccountViewState();
}

class _EditAccountViewState extends State<EditAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default phone number
    _phoneController.text = '963';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<ProfileCubit>().updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim().isEmpty
            ? null
            : _dateOfBirthController.text.trim(),
      );
    } catch (e) {
      SnackbarService.showError(
        context: context,
        title: 'خطأ',
        message: 'فشل في تحديث البيانات: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          SnackbarService.showSuccess(
            context: context,
            title: 'نجاح',
            message: 'تم تحديث بياناتك بنجاح',
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          SnackbarService.showError(
            context: context,
            title: 'خطأ',
            message: state.message,
          );
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: CustomAppBar(
              title: 'تعديل الحساب',showleading: true,
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state is ProfileLoading && _nameController.text.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 64.dp, color: AppTheme.errorColor),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'حدث خطأ',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              state.message,
              style: AppTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacing24),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileCubit>().loadProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing24,
                  vertical: AppTheme.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is ProfileLoaded) {
      // Load user data into controllers if not already loaded
      if (_nameController.text.isEmpty) {
        _nameController.text = state.user.name;
        _emailController.text = state.user.email ?? '';
        _phoneController.text = state.user.phone;
        _cityController.text = state.user.city;
      }
    }

    return _buildForm();
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacing16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar Section
            // Center(
            //   child: Column(
            //     children: [
            //       Container(
            //         width: 100.dp,
            //         height: 100.dp,
            //         decoration: BoxDecoration(
            //           color: AppTheme.primaryColor.withValues(alpha: 0.1),
            //           shape: BoxShape.circle,
            //         ),
            //         child: Icon(
            //           Iconsax.user,
            //           size: 40.dp,
            //           color: AppTheme.primaryColor,
            //         ),
            //       ),
            //       SizedBox(height: AppTheme.spacing12),
            //       Text(
            //         'تغيير الصورة الشخصية',
            //         style: AppTheme.textTheme.titleMedium?.copyWith(
            //           color: AppTheme.primaryColor,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       SizedBox(height: AppTheme.spacing4),
            //       Text(
            //         'اختر صورة من معرض الصور',
            //         style: AppTheme.textTheme.bodyMedium?.copyWith(
            //           color: AppTheme.textSecondary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: AppTheme.spacing32),

            // Personal Information Section
            Text(
              'المعلومات الشخصية',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontSize: 16.dp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                hintText: 'أدخل اسمك الكامل',
                prefixIcon: Icon(Iconsax.user, color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2.dp,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(color: AppTheme.errorColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال الاسم الكامل';
                }
                if (value.trim().length < 3) {
                  return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                }
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacing16),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني (اختياري)',
                hintText: 'أدخل بريدك الإلكتروني',
                prefixIcon: Icon(Iconsax.sms, color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2.dp,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide(color: AppTheme.errorColor),
                ),
              ),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (!value.trim().contains('@')) {
                    return 'الرجاء إدخال بريد إلكتروني صحيح';
                  }
                }
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacing16),

            // Phone Field
            CustomPhoneField(
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                
                // Remove the prefix for validation
                String phoneNumber = value.replaceAll('963', '');
                
                if (phoneNumber.length != 9) {
                  return 'رقم الهاتف يجب أن يكون 9 أرقام بعد الرمز';
                }
                
                return null;
              },
            ),

            SizedBox(height: AppTheme.spacing16),

            // Date of Birth Field
            GestureDetector(
              onTap: () async {
                BottomPicker.date(
                  headerBuilder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Iconsax.close_circle),
                          ),
                          Spacer(),
                          Text(
                            'حدد تاريخ ميلادك',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    );
                  },
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: DateTime.now(),
                  maxDateTime: DateTime(2030),
                  minDateTime: DateTime(1980),
                  onSubmit: (index) {
                    if (index != null) {
                      _dateOfBirthController.text = index
                          .toIso8601String()
                          .split('T')[0];
                    }
                  },
                  bottomPickerTheme: BottomPickerTheme.orange,
                  buttonContent: Center(
                    child: Text(
                      'اختر هذا التاريخ',
                      style: TextStyle(color: AppTheme.backgroundColor),
                    ),
                  ),
                  buttonStyle: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  ),
                  buttonWidth: Get.width - 50,
                  buttonPadding: 12,
                  backgroundColor: AppTheme.backgroundColor,
                  pickerTextStyle: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
                ).show(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateOfBirthController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الميلاد',
                    hintText: 'أدخل تاريخ الميلاد',
                    prefixIcon: Icon(
                      Iconsax.calendar,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: Icon(
                      Iconsax.calendar_1,
                      color: AppTheme.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(color: AppTheme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2.dp,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      // Basic date validation - you can enhance this as needed
                      return null;
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacing16),

            // City Field
            GestureDetector(
              onTap: () async {
                final SyrianCity? selectedCity =
                    await CitySelectorBottomSheet.show(
                      context: context,
                      selectedCity: _cityController.text.isNotEmpty
                          ? _cityController.text
                          : null,
                    );

                if (selectedCity != null) {
                  setState(() {
                    _cityController.text = selectedCity.nameAr;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _cityController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'المدينة',
                    hintText: 'اختر مدينتك',
                    prefixIcon: Icon(
                      Iconsax.location,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: Icon(
                      Iconsax.arrow_down_1,
                      color: AppTheme.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(color: AppTheme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2.dp,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء اختيار المدينة';
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacing32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50.dp,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.primaryColor.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.dp,
                            height: 20.dp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.dp,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: AppTheme.spacing12),
                          Text(
                            'جاري الحفظ...',
                            style: AppTheme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'حفظ التغييرات',
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            SizedBox(height: AppTheme.spacing16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50.dp,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  side: BorderSide(color: AppTheme.dividerColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
