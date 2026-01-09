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
        _buildSection(
          title: 'أوقات العمل',
          content: doctorInfoModel.workingTime,
        ),
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
}
