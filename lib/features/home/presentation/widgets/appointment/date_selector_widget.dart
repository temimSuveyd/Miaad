import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class DateSelectorWidget extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelectorWidget({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              padding: EdgeInsets.all(AppTheme.spacing4),
              width: 50,
              margin: EdgeInsets.only(
                right: index != dates.length - 1 ? AppTheme.spacing12 : 0,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                  width: isSelected ? 2 : 0,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date.weekday),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    date.day.toString(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }
}
