import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
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
                      color: isDestructive
                          ? AppTheme.errorColor.withValues(alpha: 0.1)
                          : AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Icon(
                      icon,
                      size: 20.dp,
                      color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
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
                            color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
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

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.dp,
                    color: AppTheme.textSecondary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
