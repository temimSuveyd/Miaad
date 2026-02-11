import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Column(
        children: [
          const Divider(height: 1, color: AppTheme.dividerColor),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.spacing12,
              horizontal: AppTheme.spacing4,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40.dp,
                  height: 40.dp,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    size: 20.dp,
                    color: AppTheme.primaryColor,
                  ),
                ),

                SizedBox(width: AppTheme.spacing12),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontSize: 14.dp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.dp),
                      Text(
                        subtitle,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.dp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppTheme.primaryColor,
                  activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                  inactiveThumbColor: AppTheme.textSecondary,
                  inactiveTrackColor: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
