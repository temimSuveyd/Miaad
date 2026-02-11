import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';
import 'notification_history_page.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadSettings(),
      child: const NotificationSettingsView(),
    );
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'إعدادات الإشعارات',
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
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
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

          if (state is SettingsLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppTheme.spacing16),

                  // Main Notifications
                  SettingsSection(
                    title: 'الإشعارات العامة',
                    children: [
                      SettingsSwitchTile(
                        icon: Iconsax.notification,
                        title: 'الإشعارات',
                        subtitle: 'تفعيل أو إيقاف جميع الإشعارات',
                        value: state.notificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleNotifications(value);
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
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Email Notifications
                  SettingsSection(
                    title: 'الإشعارات البريدية',
                    children: [
                      SettingsSwitchTile(
                        icon: Iconsax.sms,
                        title: 'البريد الإلكتروني',
                        subtitle: 'تلقي الإشعارات عبر البريد الإلكتروني',
                        value: state.emailNotificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleEmailNotifications(value);
                          if (value) {
                            SnackbarService.showSuccess(
                              context: context,
                              title: 'نجاح',
                              message: 'تم تفعيل الإشعارات البريدية',
                            );
                          } else {
                            SnackbarService.showInfo(
                              context: context,
                              title: 'معلومات',
                              message: 'تم إيقاف الإشعارات البريدية',
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Push Notifications
                  SettingsSection(
                    title: 'الإشعارات الفورية',
                    children: [
                      SettingsSwitchTile(
                        icon: Iconsax.notification_status,
                        title: 'الإشعارات الفورية',
                        subtitle: 'تلقي الإشعارات الفورية على الجهاز',
                        value: state.pushNotificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().togglePushNotifications(value);
                          if (value) {
                            SnackbarService.showSuccess(
                              context: context,
                              title: 'نجاح',
                              message: 'تم تفعيل الإشعارات الفورية',
                            );
                          } else {
                            SnackbarService.showInfo(
                              context: context,
                              title: 'معلومات',
                              message: 'تم إيقاف الإشعارات الفورية',
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Notification Types Info
                  SettingsSection(
                    title: 'أنواع الإشعارات',
                    children: [
                      _buildNotificationTypeInfo(
                        icon: Iconsax.calendar,
                        title: 'تذكيرات المواعيد',
                        description: 'تذكيرات قبل المواعيد المجدولة',
                      ),
                      _buildNotificationTypeInfo(
                        icon: Iconsax.message,
                        title: 'الرسائل',
                        description: 'رسائل من الأطباء والموظفين',
                      ),
                      _buildNotificationTypeInfo(
                        icon: Iconsax.health,
                        title: 'التحديثات الصحية',
                        description: 'معلومات وتحديثات عن صحتك',
                      ),
                      _buildNotificationTypeInfo(
                        icon: Iconsax.ticket,
                        title: 'العروض والتخفيضات',
                        description: 'عروض خاصة على الخدمات الطبية',
                      ),
                    ],
                  ),

                  SizedBox(height: AppTheme.spacing24),

                  // Notification History Section
                  SettingsSection(
                    title: 'سجل الإشعارات',
                    children: [
                      _buildNotificationHistoryOption(context),
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

  Widget _buildNotificationTypeInfo({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Column(
        children: [
          const Divider(height: 1, color: AppTheme.dividerColor),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.spacing12,
              horizontal: AppTheme.spacing4,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40.dp,
                  height: 40.dp,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    size: 20.dp,
                    color: AppTheme.primaryColor,
                  ),
                ),

                SizedBox(width: AppTheme.spacing12),

                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontSize: 14.dp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.dp),
                      Text(
                        description,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.dp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Icon
                Icon(
                  Icons.info_outline,
                  size: 16.dp,
                  color: AppTheme.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationHistoryOption(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationHistoryPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppTheme.spacing12,
          horizontal: AppTheme.spacing4,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.dp,
              height: 40.dp,
              decoration: BoxDecoration(
                color: AppTheme.categoryTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                Iconsax.notification,
                size: 20.dp,
                color: AppTheme.categoryTeal,
              ),
            ),

            SizedBox(width: AppTheme.spacing12),

            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سجل الإشعارات',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.dp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.dp),
                  Text(
                    'عرض جميع الإشعارات المستلمة',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.dp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16.dp,
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
