import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AboutTabWidget extends StatelessWidget {
  final DoctorInfoModel doctorInfoModel;
  const AboutTabWidget({super.key, required this.doctorInfoModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(title: 'نبذة عني', content: doctorInfoModel.aboutText),
          const SizedBox(height: AppTheme.spacing24),
          _buildSection(
            title: 'أوقات العمل',
            content: doctorInfoModel.workingTime,
          ),
          const SizedBox(height: AppTheme.spacing24),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          content,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
