import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/settings_section.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: const NotificationHistoryView(),
    );
  }
}

class NotificationHistoryView extends StatefulWidget {
  const NotificationHistoryView({super.key});

  @override
  State<NotificationHistoryView> createState() => _NotificationHistoryViewState();
}

class _NotificationHistoryViewState extends State<NotificationHistoryView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'سجل الإشعارات',
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
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.trash,
              color: AppTheme.textPrimary,
              size: 20.dp,
            ),
            onPressed: () {
              _showClearHistoryDialog(context);
            },
          ),
        ],
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
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: context.read<SettingsCubit>().getNotificationHistory(),
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<SettingsCubit>().loadSettings();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationCard(notification, index);
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.notification,
            size: 64.dp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: AppTheme.spacing16),
          Text(
            'لا توجد إشعارات',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'ستظهر إشعاراتك هنا',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final isRead = notification['read'] as bool? ?? false;
    final timestamp = notification['timestamp'] as String? ?? '';
    final title = notification['title'] as String? ?? '';
    final body = notification['body'] as String? ?? '';
    final channel = notification['channel'] as String? ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4.dp,
            offset: Offset(0, 2.dp),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isRead) {
              context.read<SettingsCubit>().markNotificationAsRead(notification['id'] as String);
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  width: 40.dp,
                  height: 40.dp,
                  decoration: BoxDecoration(
                    color: _getChannelColor(channel),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    _getChannelIcon(channel),
                    color: Colors.white,
                    size: 20.dp,
                  ),
                ),

                SizedBox(width: AppTheme.spacing12),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                                color: isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8.dp,
                              height: 8.dp,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppTheme.spacing4),
                      Text(
                        body,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppTheme.spacing8),
                      Text(
                        _formatTimestamp(timestamp),
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete Button
                if (!isRead)
                  IconButton(
                    icon: Icon(
                      Iconsax.trash,
                      color: AppTheme.errorColor,
                      size: 18.dp,
                    ),
                    onPressed: () {
                      _showDeleteNotificationDialog(context, notification);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getChannelColor(String? channel) {
    switch (channel) {
      case 'appointments':
        return AppTheme.categoryTeal;
      case 'messages':
        return AppTheme.categoryPurple;
      case 'promotions':
        return AppTheme.categoryOrange;
      case 'health_tips':
        return AppTheme.categoryGreen;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getChannelIcon(String? channel) {
    switch (channel) {
      case 'appointments':
        return Iconsax.calendar5;
      case 'messages':
        return Iconsax.sms;
      case 'promotions':
        return Iconsax.tag;
      case 'health_tips':
        return Iconsax.heart;
      default:
        return Iconsax.notification;
    }
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } else if (difference.inHours > 0) {
        return 'اليوم الساعة ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقائق';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return timestamp;
    }
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'مسح السجل',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontSize: 16.dp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'هل أنت متأكد من مسح سجل الإشعارات بالكامل؟ لا يمكن التراجع عن هذا الإجراء.',
          style: AppTheme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsCubit>().clearNotificationHistory();
              SnackbarService.showSuccess(
                context: context,
                title: 'نجاح',
                message: 'تم مسح سجل الإشعارات',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
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
              'مسح',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteNotificationDialog(BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف الإشعار',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontSize: 16.dp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'هل تريد حذف هذا الإشعار؟',
          style: AppTheme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete notification logic
              SnackbarService.showInfo(
                context: context,
                title: 'معلومات',
                message: 'سيتم حذف الإشعار',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
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
              'حذف',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
