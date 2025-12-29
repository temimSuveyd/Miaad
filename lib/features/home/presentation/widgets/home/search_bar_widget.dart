import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                'ابحث عن طبيب...',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
