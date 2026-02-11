import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      width: Get.width,
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
            left: AppTheme.spacing16,
            right: AppTheme.spacing16,
            // bottom: AppTheme.spacing16,
            // top: AppTheme.spacing12,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            // mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: Iconsax.home,
                  selectedIcon: Iconsax.home_15,
                  title: 'الرئيسية',
                  index: 0,
                  isActive: currentIndex == 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  selectedIcon: Iconsax.calendar5,
                  icon: Iconsax.calendar,
                  title: 'المواعيد',
                  index: 1,
                  isActive: currentIndex == 1,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.favorite_border_rounded,
                  selectedIcon: Icons.favorite,
                  title: 'المفضلة',
                  index: 3,
                  isActive: currentIndex == 3,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  title: 'إعدادات ',
                  index: 4,
                  isActive: currentIndex == 4,
                ),
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
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 70.dp,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.8, end: isActive ? 1.1 : 1),
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  begin: AppTheme.textSecondary,
                  end: isActive
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                builder: (context, color, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isActive ? selectedIcon : icon,
                          color: color,
                          size: 25.dp,
                          key: ValueKey(isActive ? selectedIcon : icon),
                        ),
                      ),
                      SizedBox(height: 3.dp),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          title,
                          key: ValueKey(title),
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontSize: 14.dp,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
