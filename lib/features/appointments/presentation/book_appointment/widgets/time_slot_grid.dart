import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final cubit = context.read<BookAppointmentCubit>();
        final times = state.availableTimes;
        final selected = state.selectedTime;

        if (times.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 48,
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد أوقات متاحة لهذا التاريخ',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 0.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final timeSlot = times[index];
            final isSelected = selected == timeSlot;

            return _TimeSlotCard(
              timeSlot: timeSlot,
              isSelected: isSelected,
              onTap: () {
                cubit.selectTime(timeSlot);
              },
            );
          },
        );
      },
    );
  }
}

class _TimeSlotCard extends StatelessWidget {
  const _TimeSlotCard({
    required this.timeSlot,
    required this.isSelected,
    required this.onTap,
  });

  final String timeSlot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.dividerColor.withValues(alpha: 0.5),
        ),
        child: Center(
          child: Text(
            timeSlot,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: isSelected
                  ? AppTheme.backgroundColor
                  : AppTheme.primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
