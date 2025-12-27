import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AboutTabWidget extends StatelessWidget {
  final String aboutText;
  final String workingTime;
  final String strNumber;
  final String practicePlace;
  final String practiceYears;

  const AboutTabWidget({
    super.key,
    required this.aboutText,
    required this.workingTime,
    required this.strNumber,
    required this.practicePlace,
    required this.practiceYears,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'About me',
            content: aboutText,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildSection(
            title: 'Working Time',
            content: workingTime,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildSection(
            title: 'STR',
            content: strNumber,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildSection(
            title: 'Pengalaman Praktik',
            content: practicePlace,
            subcontent: practiceYears,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    String? subcontent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        if (subcontent != null) ...[
          const SizedBox(height: AppTheme.spacing4),
          Text(
            subcontent,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}