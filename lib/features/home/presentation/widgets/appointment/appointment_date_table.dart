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

            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppTheme.textSecondary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: -4,
                  ),
                ],
                // border: Border.all(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Container(
                padding: EdgeInsets.all(AppTheme.spacing4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  color: AppTheme.cardBackground,
                ),
                child: TableCalendar(
                  headerVisible: true,
                  rowHeight: 35,
                  daysOfWeekHeight: 40,
                  focusedDay: DateTime(2025, 2, 10),
                  firstDay: DateTime(2025, 10, 10),
                  lastDay: DateTime(2025, 10, 20),
                  onDaySelected: (selectedDay, focusedDay) {
                    cubit.selectDateTime();
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
