import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 0.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => _TimeSlotCard(isSelected: index == 2),
    );
  }
}

class _TimeSlotCard extends StatelessWidget {
  const _TimeSlotCard({super.key, required this.isSelected});
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        color: isSelected
            ? AppTheme.primaryColor
            : AppTheme.dividerColor.withOpacity(0.5),
      ),
      child: Center(
        child: Text(
          '09:00 AM',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: isSelected
                ? AppTheme.backgroundColor
                : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
