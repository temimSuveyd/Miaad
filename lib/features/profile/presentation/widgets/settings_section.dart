import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.dp,
            offset: Offset(0, 2.dp),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.all(AppTheme.spacing16),
            child: Text(
              title,
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 16.dp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          // Section Children
          ...children,
        ],
      ),
    );
  }
}
