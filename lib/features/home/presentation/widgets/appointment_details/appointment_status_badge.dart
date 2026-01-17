import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/appointments_model.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentsModel appointment;

  const AppointmentStatusBadge({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing24,
          vertical: AppTheme.spacing12,
        ),
        decoration: BoxDecoration(
          color: appointment.getStatusColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          border: Border.all(
            color: appointment.getStatusColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              appointment.getStatusIcon(),
              color: appointment.getStatusColor(),
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              appointment.getStatusText(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appointment.getStatusColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
