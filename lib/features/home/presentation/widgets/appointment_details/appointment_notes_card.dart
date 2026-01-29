import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../appointments/data/models/appointment.dart';

class AppointmentNotesCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentNotesCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    if (appointment.notes == null || appointment.notes!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_outlined, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: AppTheme.spacing8),
              Text('ملاحظات', style: AppTheme.sectionTitle),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            appointment.notes!,
            style: AppTheme.bodyMedium.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
