import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing32,
            vertical: AppTheme.spacing8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(
                icon: Iconsax.home,
                selectedIcon: Iconsax.home_15,
                index: 0,
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                selectedIcon: Iconsax.calendar5,
                icon: Iconsax.calendar,
                index: 1,
                isActive: currentIndex == 1,
              ),

              _buildNavItem(
                icon: Icons.favorite_border_rounded,
                selectedIcon: Icons.favorite,
                index: 3,
                isActive: currentIndex == 3,
              ),
              _buildNavItem(
                icon: Iconsax.profile_circle,
                selectedIcon: Iconsax.profile_circle5,
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
        height: 50,
        width: 50,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.dividerColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: AppTheme.textSecondary,
            end: isActive
                ? AppTheme.textPrimary
                : AppTheme.textSecondary.withOpacity(0.8),
          ),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          builder: (context, color, child) {
            return Icon(isActive ? selectedIcon : icon, color: color, size: 24);
          },
        ),
      ),
    );
  }
}
