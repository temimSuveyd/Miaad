import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class DoctorStatsWidget extends StatelessWidget {
  final int experienceYears;
  final int patientsCount;
  final double reviewsCount;

  const DoctorStatsWidget({
    super.key,
    required this.experienceYears,
    required this.patientsCount,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          value: '${experienceYears}years',
          label: 'Experience',
        ),
        _buildDivider(),
        _buildStatItem(
          value: patientsCount.toString(),
          label: 'Patients',
        ),
        _buildDivider(),
        _buildStatItem(
          value: reviewsCount >= 1000
              ? '${(reviewsCount / 1000).toStringAsFixed(1)}k'
              : reviewsCount.toStringAsFixed(1),
          label: 'Reviews',
          icon: Icons.star,
          iconColor: const Color(0xFFFFB800),
        ),
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
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppTheme.dividerColor,
    );
  }
}