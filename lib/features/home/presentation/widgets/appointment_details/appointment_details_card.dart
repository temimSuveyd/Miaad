import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../shared/appointments/data/models/appointment.dart';
import '../../../../shared/appointments/data/models/slot_model.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
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
          Text('تفاصيل الموعد', style: AppTheme.sectionTitle),
          const SizedBox(height: AppTheme.spacing20),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'التاريخ',
            value: DateFormatter.formatAppointmentDate(appointment.date),
          ),
          const SizedBox(height: AppTheme.spacing16),
          _DetailRow(
            icon: Icons.access_time_outlined,
            label: 'الوقت',
            value: DateFormatter.formatTimeString(appointment.time),
          ),
          const SizedBox(height: AppTheme.spacing16),
          _DetailRow(
            icon: Icons.person_outline,
            label: 'اسم المريض',
            value: appointment.userName ?? 'مريض غير معروف',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _DetailRow(
            icon: Icons.confirmation_number_outlined,
            label: 'رقم الموعد',
            value: appointment.id!,
          ),
          // Show slot information if available
          if (appointment.hasSlot) ...[
            const SizedBox(height: AppTheme.spacing16),
            _DetailRow(
              icon: Icons.access_time,
              label: 'نوع الحجز',
              value: appointment.appointmentType,
            ),
            if (appointment.slotId != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              _DetailRow(
                icon: Icons.access_time,
                label: 'رقم السلوت',
                value: appointment.slotId!,
              ),
            ],
            if (appointment.slotDuration != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              _DetailRow(
                icon: Icons.hourglass_bottom_outlined,
                label: 'مدة السلوت',
                value: '${appointment.slotDuration} دقيقة',
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                value,
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
