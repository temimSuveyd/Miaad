import 'package:doctorbooking/features/shared/appointments/data/models/doctor_schedule_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Widget لعرض جدول عمل الطبيب
/// Doctor Schedule Widget
class DoctorScheduleWidget extends StatelessWidget {
  final List<DoctorScheduleModel> schedules;
  final bool isLoading;
  final String? errorMessage;

  const DoctorScheduleWidget({
    super.key,
    required this.schedules,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingWidget();
    }

    if (errorMessage != null) {
      return _buildErrorWidget();
    }

    if (schedules.isEmpty) {
      return _buildEmptyWidget();
    }

    return _buildScheduleWidget();
  }

  /// Widget للتحميل
  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          ...List.generate(3, (index) => _buildShimmerItem()),
        ],
      ),
    );
  }

  /// Widget للخطأ
  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.error_outline,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  'ساعات العمل',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            errorMessage ?? 'فشل في تحميل ساعات العمل',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Widget للحالة الفارغة
  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.access_time_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  'ساعات العمل',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    'الطبيب لم يحدد ساعات العمل بعد',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget لعرض الجدول
  Widget _buildScheduleWidget() {
    if (schedules.isEmpty) {
      return _buildEmptyWidget();
    }

    // ترتيب الجدول حسب اليوم
    final sortedSchedules = List<DoctorScheduleModel>.from(schedules)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.schedule_outlined,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  'ساعات العمل',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          
          // معلومات العمل المدمجة
          _buildCompactScheduleInfo(sortedSchedules),
        ],
      ),
    );
  }

  /// Widget لعرض معلومات العمل المدمجة
  Widget _buildCompactScheduleInfo(List<DoctorScheduleModel> schedules) {
    if (schedules.isEmpty) return const SizedBox.shrink();

    // الحصول على أيام العمل المتتالية
    final dayRange = _getDayRange(schedules);
    final timeRange = _getTimeRange(schedules);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          // أيام الأسبوع
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  dayRange,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        
        
          // ساعات العمل
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  timeRange,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على نطاق الأيام (مثال: السبت - الأربعاء)
  String _getDayRange(List<DoctorScheduleModel> schedules) {
    if (schedules.isEmpty) return '';
    
    final activeSchedules = schedules.where((s) => s.isActive).toList();
    if (activeSchedules.isEmpty) return 'لا توجد أيام عمل';
    
    // ترتيب الأيام
    activeSchedules.sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
    
    final firstDay = activeSchedules.first.dayNameArabic;
    final lastDay = activeSchedules.last.dayNameArabic;
    
    if (activeSchedules.length == 1) {
      return firstDay;
    } else {
      return '$firstDay - $lastDay';
    }
  }

  String _getTimeRange(List<DoctorScheduleModel> schedules) {
    if (schedules.isEmpty) return '';
    
    final activeSchedules = schedules.where((s) => s.isActive).toList();
    if (activeSchedules.isEmpty) return 'لا توجد ساعات عمل';
    
    // الحصول على أوقات البدء والانتهاء
    final startTimes = activeSchedules.map((s) => s.startTime).toList();
    final endTimes = activeSchedules.map((s) => s.endTime).toList();
    
    // تحويل إلى 12-hour format
    final startTime = _formatTime(startTimes.first);
    final endTime = _formatTime(endTimes.last);
    
    return '$startTime - $endTime';
  }

  /// تحويل الوقت إلى 12-hour format
  String _formatTime(String time24) {
    final parts = time24.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    
    return '$hour12:${minute} $period';
  }

  /// Widget للشimmer تأثير
  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
    );
  }
}
