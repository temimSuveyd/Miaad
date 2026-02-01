import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentDateTable extends StatelessWidget {
  const AppointmentDateTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر التاريخ', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing16),
        BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
            final cubit = context.read<BookAppointmentCubit>();

            // الحصول على التاريخ المحدد من الحالة
            final selected = state.selectedDate;
            final slots = state.availableSlots;
            final focusedDay = selected ?? DateTime.now();

            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 0),
                    color: AppTheme.textSecondary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: -4,
                  ),
                ],
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              // child: Container(
              //   padding: const EdgeInsets.all(AppTheme.spacing4),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              //     color: AppTheme.cardBackground,
              //   ),
              //   child: TableCalendar(
              //     firstDay: DateTime.now(),
              //     lastDay: DateTime.now().add(const Duration(days: 90)),
              //     focusedDay: focusedDay,
              //     selectedDayPredicate: (day) {
              //       return isSameDay(selected, day);
              //     },
              //     onDaySelected: (selectedDay, focusedDay) {
              //       cubit.selectDate(selectedDay);
              //     },
              //     calendarFormat: CalendarFormat.month,
              //     startingDayOfWeek: StartingDayOfWeek.saturday,
              //     rowHeight: 35,
              //     daysOfWeekHeight: 40,
              //     headerStyle: const HeaderStyle(
              //       formatButtonVisible: false,
              //       titleCentered: true,
              //       titleTextStyle: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //         color: AppTheme.textPrimary,
              //       ),
              //     ),
              //     calendarStyle: CalendarStyle(
              //       todayDecoration: BoxDecoration(
              //         color: AppTheme.primaryColor.withValues(alpha: 0.3),
              //         shape: BoxShape.circle,
              //       ),
              //       selectedDecoration: const BoxDecoration(
              //         color: AppTheme.primaryColor,
              //         shape: BoxShape.circle,
              //       ),
              //       selectedTextStyle: const TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //       todayTextStyle: const TextStyle(
              //         color: AppTheme.primaryColor,
              //         fontWeight: FontWeight.bold,
              //       ),
              //       defaultTextStyle: const TextStyle(
              //         color: AppTheme.textPrimary,
              //       ),
              //       weekendTextStyle: const TextStyle(
              //         color: AppTheme.textPrimary,
              //       ),
              //       outsideTextStyle: const TextStyle(
              //         color: AppTheme.textSecondary,
              //       ),
              //     ),
              //     enabledDayPredicate: (day) {
              //       // تعطيل الأيام السابقة والأيام التي لا تحتوي على أوقات متاحة
              //       final isAfterToday = day.isAfter(
              //         DateTime.now().subtract(const Duration(days: 1)),
              //       );
              //       final hasAvailableSlots =
              //           slots.containsKey(day) && slots[day]!.isNotEmpty;

              //       return isAfterToday && hasAvailableSlots;
              //     },
              //     // إضافة مؤشرات للأيام المتاحة
              //     calendarBuilders: CalendarBuilders(
              //       markerBuilder: (context, day, events) {
              //         if (slots.containsKey(day) && slots[day]!.isNotEmpty) {
              //           return Positioned(
              //             bottom: 1,
              //             child: Container(
              //               width: 6,
              //               height: 6,
              //               decoration: BoxDecoration(
              //                 color: isSameDay(selected, day)
              //                     ? Colors.white
              //                     : AppTheme.primaryColor,
              //                 shape: BoxShape.circle,
              //               ),
              //             ),
              //           );
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              // ),
            );
          },
        ),
      ],
    );
  }
}
