import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../theme/app_theme.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.dp,
            offset: Offset(0, -2.dp),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppTheme.spacing32,
            right: AppTheme.spacing32,
            bottom: AppTheme.spacing16,
            top: AppTheme.spacing12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(
                icon: Iconsax.home,
                selectedIcon: Iconsax.home_15,
                title: 'الرئيسية',
                index: 0,
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                selectedIcon: Iconsax.calendar5,
                icon: Iconsax.calendar,
                title: 'المواعيد',
                index: 1,
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.favorite_border_rounded,
                selectedIcon: Icons.favorite,
                title: 'المفضلة',
                index: 3,
                isActive: currentIndex == 3,
              ),
              _buildNavItem(
                icon: Iconsax.profile_circle,
                selectedIcon: Iconsax.profile_circle5,
                title: 'الحساب',
                index: 4,
                isActive: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required IconData selectedIcon,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 40.dp,
        width: isActive ? 100.dp : 50.dp,
        padding: EdgeInsets.all(AppTheme.spacing4),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.dividerColor.withOpacity(0.6)
              : Colors.transparent,
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: AppTheme.textSecondary,
            end: isActive
                ? AppTheme.primaryColor
                : AppTheme.textSecondary.withValues(alpha: 0.8),
          ),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          builder: (context, color, child) {
            return Center(
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? selectedIcon : icon,
                    color: color,
                    size: 22.dp,
                  ),
                  if (isActive) Text(title),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
