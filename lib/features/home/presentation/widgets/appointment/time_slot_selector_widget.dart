import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class TimeSlotSelectorWidget extends StatelessWidget {
  final String? selectedTime;
  final Function(String) onTimeSelected;
  final List<String> availableTimes;

  const TimeSlotSelectorWidget({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    required this.availableTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        // Time slots grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppTheme.spacing12,
            mainAxisSpacing: AppTheme.spacing12,
            childAspectRatio: 2.5,
          ),
          itemCount: availableTimes.length,
          itemBuilder: (context, index) {
            final time = availableTimes[index];
            final isSelected = time == selectedTime;
            return GestureDetector(
              onTap: () => onTimeSelected(time),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor2
                        : AppTheme.dividerColor,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primaryColor2
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
