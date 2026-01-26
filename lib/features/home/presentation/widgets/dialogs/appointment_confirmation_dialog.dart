import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';

class AppointmentConfirmationDialog extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String? doctorImageUrl;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AppointmentConfirmationDialog({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    this.doctorImageUrl,
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    String? doctorImageUrl,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppointmentConfirmationDialog(
        doctorName: doctorName,
        specialty: specialty,
        date: date,
        time: time,
        doctorImageUrl: doctorImageUrl,
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm();
        },
        onCancel: () {
          Navigator.of(context).pop(false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.calendar_tick5,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),

            // Title
            Text(
              'تأكيد الموعد',
              style: AppTheme.heading2.copyWith(color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),

            // Subtitle
            Text(
              'هل أنت متأكد من حجز هذا الموعد؟',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),

            // Appointment Details Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.dividerColor, width: 1),
              ),
              child: Column(
                children: [
                  // Doctor Info
                  Row(
                    children: [
                      // Doctor Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                          image: doctorImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(doctorImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: doctorImageUrl == null
                            ? const Icon(
                                Iconsax.user,
                                size: 30,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppTheme.spacing12),

                      // Doctor Name & Specialty
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppTheme.spacing4),
                            Text(
                              specialty,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacing16),

                  // Divider
                  Container(height: 1, color: AppTheme.dividerColor),

                  const SizedBox(height: AppTheme.spacing16),

                  // Date & Time
                  Row(
                    children: [
                      // Date
                      Expanded(
                        child: _buildInfoItem(
                          icon: Iconsax.calendar_1,
                          label: 'التاريخ',
                          value: date,
                        ),
                      ),

                      const SizedBox(width: AppTheme.spacing12),

                      // Time
                      Expanded(
                        child: _buildInfoItem(
                          icon: Iconsax.clock,
                          label: 'الوقت',
                          value: time,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      side: const BorderSide(
                        color: AppTheme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppTheme.spacing12),

                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تأكيد الحجز',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacing4),
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
