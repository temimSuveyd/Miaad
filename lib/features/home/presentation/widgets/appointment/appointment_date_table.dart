import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentDateTable extends StatelessWidget {
  const AppointmentDateTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر التاريخ', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: AppTheme.spacing16),
        BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
            final BookAppointmentCubit cubit = context
                .read<BookAppointmentCubit>();

            // الحصول على التاريخ المحدد من الحالة
            DateTime? selectedDay;
            DateTime focusedDay = DateTime.now();

            if (state is AppointmentDateTimeSelected &&
                state.selectedDate != null) {
              selectedDay = state.selectedDate;
              focusedDay = state.selectedDate!;
            }

            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppTheme.textSecondary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: -4,
                  ),
                ],
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Container(
                padding: EdgeInsets.all(AppTheme.spacing4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  color: AppTheme.cardBackground,
                ),
                child: TableCalendar(
                  // locale: 'ar',
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 90)),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    // تحديث التاريخ في الـ Cubit فقط
                    cubit.selectDateTime(date: selectedDay);
                  },
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  rowHeight: 35,
                  daysOfWeekHeight: 40,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(color: AppTheme.textPrimary),
                    weekendTextStyle: TextStyle(color: AppTheme.textPrimary),
                    outsideTextStyle: TextStyle(color: AppTheme.textSecondary),
                  ),
                  enabledDayPredicate: (day) {
                    // تعطيل الأيام السابقة
                    return day.isAfter(
                      DateTime.now().subtract(Duration(days: 1)),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
