import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Base dialog widget with consistent styling
class BaseDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget content;
  final List<Widget> actions;
  final bool showCloseButton;

  const BaseDialog({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.content,
    required this.actions,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            if (showCloseButton)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 24,
                  color: AppTheme.textSecondary,
                ),
              ),

            // Icon
            icon,
            const SizedBox(height: AppTheme.spacing20),

            // Title
            Text(
              title,
              style: AppTheme.heading2.copyWith(color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(
                subtitle!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: AppTheme.spacing24),

            // Content
            content,

            const SizedBox(height: AppTheme.spacing24),

            // Actions
            Row(
              children: actions
                  .expand(
                    (action) => [
                      Expanded(child: action),
                      if (action != actions.last)
                        const SizedBox(width: AppTheme.spacing12),
                    ],
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog icon widget
class DialogIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const DialogIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}
