import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AboutTabWidget extends StatelessWidget {
  final DoctorInfoModel doctorInfoModel;
  const AboutTabWidget({super.key, required this.doctorInfoModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(title: 'نبذة عني', content: doctorInfoModel.aboutText),
        const SizedBox(height: AppTheme.spacing20),
        Container(height: 1, color: AppTheme.dividerColor),
        const SizedBox(height: AppTheme.spacing20),
        _buildWorkingHoursSection(doctorInfoModel.workingTime),
      ],
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.sectionTitle.copyWith(fontSize: 16)),
        const SizedBox(height: AppTheme.spacing12),
        Text(
          content,
          style: AppTheme.bodyMedium.copyWith(height: 1.6, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursSection(Map workingTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أوقات العمل',
          style: AppTheme.sectionTitle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(children: _buildWorkingHoursList(workingTime)),
        ),
      ],
    );
  }

  List<Widget> _buildWorkingHoursList(Map workingTime) {
    if (workingTime.isEmpty) {
      return [
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              'غير محدد',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ];
    }

    List<Widget> hoursList = [];

    workingTime.forEach((day, time) {
      hoursList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    day.toString(),
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  time.toString(),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return hoursList;
  }
}
