import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Widget لعرض حالة عدم وجود سلوتس متاحة
/// No Slots Available Widget
class NoSlotsWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const NoSlotsWidget({
    super.key,
    required this.message,
    this.icon = Icons.calendar_today_outlined,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'لا توجد مواعيد متاحة',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacing32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: AppTheme.spacing16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget خاص لحالة عدم وجود ساعات عمل
/// No Working Hours Widget
class NoWorkingHoursWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoWorkingHoursWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return NoSlotsWidget(
      message: 'الطبيب لم يحدد ساعات العمل بعد. يرجى المحاولة مرة أخرى لاحقاً.',
      icon: Icons.access_time_outlined,
      onRetry: onRetry,
    );
  }
}

/// Widget خاص لحالة عدم وجود سلوتس متاحة
/// No Available Slots Widget
class NoAvailableSlotsWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoAvailableSlotsWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return NoSlotsWidget(
      message: 'جميع المواعيد محجوزة حالياً. يرجى المحاولة في تاريخ آخر.',
      icon: Icons.event_busy_outlined,
      onRetry: onRetry,
    );
  }
}
