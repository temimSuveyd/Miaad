import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.dp,
        vertical: AppTheme.spacing12.dp,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall.dp),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal,
            color: AppTheme.textSecondary,
            size: 20.dp,
          ),
          SizedBox(width: AppTheme.spacing12.dp),
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
    );
  }
}
