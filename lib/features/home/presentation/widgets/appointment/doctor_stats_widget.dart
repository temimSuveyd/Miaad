import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/doctor_model.dart';

class DoctorStatsWidget extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorStatsWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing20,
        vertical: AppTheme.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
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
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    IconData? icon,
    Color? iconColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: AppTheme.spacing4),
              ],
              Text(
                value,
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(label, style: AppTheme.caption),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppTheme.dividerColor);
  }
}
