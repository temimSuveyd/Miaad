import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/features/home/presentation/widgets/my_appointments/appointments_tab_bar_widget.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
AppBar MyAppointmentAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppTheme.backgroundColor,
    elevation: 0,

    title: const Text(
      'My Appointment',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    ),
    leading: SizedBox(),
    centerTitle: true,
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(68),
      child: AppointmentsTabBarWidget(),
    ),
  );
}
