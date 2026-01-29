import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeeklySchedule extends StatelessWidget {
  const WeeklySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final cubit = context.read<BookAppointmentCubit>();
        final availableSlots = state.availableSlots;
        final selectedDate = state.selectedDate;

        if (availableSlots.isEmpty) {
          return _buildEmptyState();
        }

        // ترتيب الأيام حسب التاريخ
        final sortedDates = availableSlots.keys.toList()
          ..sort((a, b) => a.compareTo(b));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر اليوم والوقت',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing16),
            ...sortedDates.map((date) {
              final timeSlots = availableSlots[date] ?? [];
              final isSelected =
                  selectedDate != null &&
                  selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;

              return _buildDaySchedule(
                context,
                date,
                timeSlots,
                isSelected,
                cubit,
                state.selectedTime,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مواعيد متاحة هذا الأسبوع',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule(
    BuildContext context,
    DateTime date,
    List<String> timeSlots,
    bool isDaySelected,
    BookAppointmentCubit cubit,
    String? selectedTime,
  ) {
    final dayName = _getDayName(date);
    final dateText = DateFormat('dd/MM').format(date);
    final isToday = _isToday(date);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isDaySelected
              ? AppTheme.primaryColor
              : AppTheme.dividerColor.withValues(alpha: 0.3),
          width: isDaySelected ? 2 : 1,
        ),
        color: isDaySelected
            ? AppTheme.primaryColor.withValues(alpha: 0.05)
            : AppTheme.cardBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس اليوم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: isDaySelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.dividerColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isDaySelected
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'اليوم',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // الأوقات المتاحة
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: timeSlots.map((time) {
                final isTimeSelected = isDaySelected && selectedTime == time;

                return GestureDetector(
                  onTap: () {
                    cubit.selectDate(date);
                    cubit.selectTime(time);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isTimeSelected
                          ? AppTheme.primaryColor
                          : AppTheme.dividerColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(
                        color: isTimeSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      time,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isTimeSelected
                            ? Colors.white
                            : AppTheme.textPrimary,
                        fontWeight: isTimeSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final dayNames = {
      DateTime.saturday: 'السبت',
      DateTime.sunday: 'الأحد',
      DateTime.monday: 'الاثنين',
      DateTime.tuesday: 'الثلاثاء',
      DateTime.wednesday: 'الأربعاء',
      DateTime.thursday: 'الخميس',
      DateTime.friday: 'الجمعة',
    };
    return dayNames[date.weekday] ?? '';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
