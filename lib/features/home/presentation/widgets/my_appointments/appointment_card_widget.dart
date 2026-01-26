import 'package:doctorbooking/features/home/presentation/cubit/my_appointments_cubit/my_appointments_cubit.dart';
import 'package:doctorbooking/features/home/presentation/widgets/dialogs/reschedule_appointment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/models/appointments_model.dart';

// ويدجت بطاقة الموعد
class AppointmentCardWidget extends StatelessWidget {
  final AppointmentsModel appointment;
  final bool isUpcoming;
  final bool isCompleted;
  final bool isCancelled;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.isUpcoming = false,
    this.isCompleted = false,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isUpcoming) _buildStatusText(),
          if (!isUpcoming) const Divider(color: AppTheme.dividerColor),

          // معلومات الموعد
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة الطبيب
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                // معلومات الطبيب والموعد
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName ?? 'Unknown Doctor',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        appointment.hospitalName ?? 'Unknown Hospital',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      if (isUpcoming)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormatter.formatShort(appointment.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            Text(
                              DateFormatter.formatTimeString(appointment.time),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isUpcoming) const Divider(color: AppTheme.dividerColor),

          // حالة الموعد والأزرار
          if (isUpcoming) _buildUpcomingActions(context),
        ],
      ),
    );
  }

  // بناء أزرار المواعيد القادمة
  Widget _buildUpcomingActions(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _showCancelDialog(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showRescheduleDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Reschedule',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض حوار تأكيد الإلغاء
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // استدعاء cubit لإلغاء الموعد
              context.read<MyAppointmentsCubit>().cancelAppointment(
                appointment.id!,
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  // عرض حوار إعادة جدولة الموعد
  void _showRescheduleDialog(BuildContext context) {
    RescheduleAppointmentDialog.show(
      context: context,
      appointment: appointment,
      onReschedule: (DateTime newDate, String newTime) {
        context.read<MyAppointmentsCubit>().rescheduleAppointment(
          appointment.id!,
          newDate,
          newTime,
        );
      },
    );
  }

  // بناء نص الحالة للمواعيد المكتملة والملغاة
  Widget _buildStatusText() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isCompleted ? 'Appointment done' : 'Appointment cancelled',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: _getStatusTextColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  DateFormatter.formatShort(appointment.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  DateFormatter.formatTimeString(appointment.time),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        if (isCompleted || isCancelled)
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
            onPressed: () {
              _showOptionsMenu(Get.context!);
            },
          ),
      ],
    );
  }

  // الحصول على لون نص الحالة
  Color _getStatusTextColor() {
    if (isCompleted) {
      return const Color(0xFF4CAF50); // أخضر
    } else {
      return const Color(0xFFF44336); // أحمر
    }
  }

  // عرض قائمة الخيارات
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusXLarge),
            topRight: Radius.circular(AppTheme.radiusXLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppTheme.spacing12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: AppTheme.primaryColor,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View details feature coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.receipt_outlined,
                color: AppTheme.primaryColor,
              ),
              title: const Text('View Receipt'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View receipt feature coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            if (isCompleted)
              ListTile(
                leading: const Icon(
                  Icons.rate_review_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Write Review'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Write review feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            if (isCompleted || isCancelled)
              ListTile(
                leading: const Icon(
                  Icons.schedule,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Book Again'),
                onTap: () {
                  Navigator.pop(context);
                  _showRescheduleDialog(context);
                },
              ),
            const SizedBox(height: AppTheme.spacing20),
          ],
        ),
      ),
    );
  }
}
