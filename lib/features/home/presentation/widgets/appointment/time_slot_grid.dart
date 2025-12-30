import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/home/data/mock/mock_appointments_data.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final cubit = context.read<BookAppointmentCubit>();
        String? selectedTime;

        if (state is AppointmentDateTimeSelected) {
          selectedTime = state.selectedTime;
        }

        return SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 0.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: MockAppointmentsData.availableTimeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = MockAppointmentsData.availableTimeSlots[index];
            final isSelected = selectedTime == timeSlot;

            return _TimeSlotCard(
              timeSlot: timeSlot,
              isSelected: isSelected,
              onTap: () {
                cubit.selectDateTime(time: timeSlot);
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
