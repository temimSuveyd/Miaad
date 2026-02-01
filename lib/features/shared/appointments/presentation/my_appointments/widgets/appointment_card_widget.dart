import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../data/models/my_appointment_model.dart';

// ويدجت بطاقة الموعد
class AppointmentCardWidget extends StatelessWidget {
  final MyAppointmentModel appointment;
  final Function(String)? onCancel;
  final Function(String, DateTime, String)? onReschedule;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
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
          // حالة الموعد
          _buildStatusHeader(),
          const Divider(color: AppTheme.dividerColor),

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
                        appointment.appointment.doctorName ?? 'Unknown Doctor',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        appointment.appointment.hospitalName ??
                            'Unknown Hospital',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormatter.formatShort(
                              appointment.appointment.date,
                            ),
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
                            DateFormatter.formatTimeString(
                              appointment.appointment.time,
                            ),
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

          // الأزرار إذا كانت متاحة
          if (appointment.hasActions) ...[
            const Divider(color: AppTheme.dividerColor),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  // بناء رأس الحالة
  Widget _buildStatusHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: appointment.appointment.getStatusColor().withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                appointment.appointment.getStatusIcon(),
                size: 16,
                color: appointment.appointment.getStatusColor(),
              ),
              const SizedBox(width: 4),
              Text(
                appointment.statusDisplayText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: appointment.appointment.getStatusColor(),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
          onPressed: () => _showOptionsMenu(Get.context!),
        ),
      ],
    );
  }

  // بناء أزرار الإجراءات
  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          if (appointment.canCancel) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                  side: const BorderSide(color: AppTheme.errorColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            if (appointment.canReschedule)
              const SizedBox(width: AppTheme.spacing12),
          ],
          if (appointment.canReschedule)
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showRescheduleDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'إعادة جدولة',
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
        title: const Text('إلغاء الموعد'),
        content: const Text('هل أنت متأكد من إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (onCancel != null) {
                onCancel!(appointment.appointment.id!);
              }
            },
            child: const Text(
              'نعم، إلغاء',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  // عرض حوار إعادة جدولة الموعد
  void _showRescheduleDialog(BuildContext context) {
    // يمكن تنفيذ هذا لاحقاً
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ميزة إعادة الجدولة قيد التطوير'),
        duration: Duration(seconds: 2),
      ),
    );
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
              title: const Text('عرض التفاصيل'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ميزة عرض التفاصيل قيد التطوير'),
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
              title: const Text('عرض الإيصال'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ميزة عرض الإيصال قيد التطوير'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: AppTheme.spacing20),
          ],
        ),
      ),
    );
  }
}
