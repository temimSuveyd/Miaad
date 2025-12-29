import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/doctor_model.dart';

class DoctorProfileHeaderWidget extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onMessageTap;

  const DoctorProfileHeaderWidget({
    super.key,
    required this.doctor,
    this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Image.network(
              doctor.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, size: 40),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                doctor.specialty,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                doctor.price,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
