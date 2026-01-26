import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.textSecondary.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 24,
                color: isLogout ? AppTheme.errorColor : AppTheme.textSecondary,
              ),
            ),

            const SizedBox(width: AppTheme.spacing16),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? AppTheme.errorColor : AppTheme.textPrimary,
                ),
              ),
            ),

            // Arrow Icon (only for non-logout items)
            if (!isLogout)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }
}
