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
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNavItem(
                icon: Iconsax.home,
                index: 0,
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Iconsax.calendar,
                index: 1,
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Iconsax.message,
                index: 2,
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                icon: Iconsax.save_2,
                index: 3,
                isActive: currentIndex == 3,
              ),
              _buildNavItem(
                icon: Iconsax.profile_2user,
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
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isActive
                  ? AppTheme.primaryColor
                  : AppTheme.backgroundColor,
              width: 2,
            ),
          ),
        ),
        child: AnimatedScale(
          scale: isActive ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: AppTheme.textSecondary,
              end: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, color, child) {
              return Icon(
                icon,
                color: color,
                size: 26,
              );
            },
          ),
        ),
      ),
    );
  }
}
