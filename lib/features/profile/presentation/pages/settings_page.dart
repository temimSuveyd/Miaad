import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_menu_tile.dart';
import 'edit_account_page.dart';
import 'help_support_page.dart';
import 'notification_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadSettings(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإعدادات',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.dp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textPrimary,
            size: 20.dp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.warning_2,
                    size: 64.dp,
                    color: AppTheme.errorColor,
                  ),
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
                      context.read<SettingsCubit>().loadSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing24,
                        vertical: AppTheme.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
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

          if (state is SettingsLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppTheme.spacing16),

                  // Account Section
                  SettingsSection(
                    title: 'الحساب',
                    children: [
                      SettingsMenuTile(
                        icon: Iconsax.user_edit,
                        title: 'تعديل الحساب',
                        subtitle: 'تحديث معلوماتك الشخصية',
                        onTap: () => Get.toNamed(AppRoutes.editAccountPage),
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Notifications Section
                  SettingsSection(
                    title: 'الإشعارات',
                    children: [
                      SettingsSwitchTile(
                        icon: Iconsax.notification,
                        title: 'الإشعارات',
                        subtitle: 'تفعيل أو إيقاف جميع الإشعارات',
                        value: state.notificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleNotifications(
                            value,
                          );
                          if (value) {
                            SnackbarService.showSuccess(
                              context: context,
                              title: 'نجاح',
                              message: 'تم تفعيل الإشعارات',
                            );
                          } else {
                            SnackbarService.showInfo(
                              context: context,
                              title: 'معلومات',
                              message: 'تم إيقاف الإشعارات',
                            );
                          }
                        },
                      ),
                      SettingsMenuTile(
                        icon: Iconsax.notification_status,
                        title: 'إعدادات الإشعارات',
                        subtitle: 'تخصيص أنواع الإشعارات',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Support Section
                  SettingsSection(
                    title: 'الدعم',
                    children: [
                      SettingsMenuTile(
                        icon: Iconsax.sms,
                        title: 'المساعدة والدعم',
                        subtitle: 'الحصول على المساعدة وطرح الأسئلة',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Danger Zone Section
                  SettingsSection(
                    title: 'خطر',
                    children: [
                      SettingsMenuTile(
                        icon: Iconsax.logout,
                        title: 'تسجيل الخروج',
                        subtitle: 'تسجيل الخروج من حسابك',
                        isDestructive: true,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing32),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.dp,
              height: 4.dp,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.dp),
              ),
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'تسجيل الخروج',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontSize: 18.dp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacing32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.dp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                        side: const BorderSide(color: AppTheme.textSecondary),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      settingsCubit.signOut().then((_) {
                        Get.offAllNamed(AppRoutes.login);
                        SnackbarService.showSuccess(
                          context: context,
                          title: 'نجاح',
                          message: 'تم تسجيل الخروج بنجاح',
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.dp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                    ),
                    child: Text(
                      'تسجيل الخروج',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacing16),
          ],
        ),
      ),
    );
  }
}
