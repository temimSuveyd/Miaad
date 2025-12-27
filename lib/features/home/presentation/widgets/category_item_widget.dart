import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryItemWidget extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const CategoryItemWidget({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            // child: SvgPicture.asset(
            //   iconPath,
            //   width: 32,
            //   height: 32,
            //   colorFilter: const ColorFilter.mode(
            //     AppTheme.textPrimary,
            //     BlendMode.srcIn,
            //   ),
            // ),
            child: Icon(Iconsax.heart_add),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
