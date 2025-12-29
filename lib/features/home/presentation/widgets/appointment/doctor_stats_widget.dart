import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/doctor_model.dart';

class DoctorStatsWidget extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorStatsWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          value: doctor.rating.toStringAsFixed(1),
          label: 'التقييم',
          icon: Icons.star,
          iconColor: const Color(0xFFFFB800),
        ),
        _buildDivider(),
        _buildStatItem(value: '2.5k+', label: 'المرضى'),
        _buildDivider(),
        _buildStatItem(value: '10+ سنوات', label: 'الخبرة'),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppTheme.dividerColor);
  }
}
