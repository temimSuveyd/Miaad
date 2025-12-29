import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ويدجت شريط التبويبات للمواعيد
class AppointmentsTabBarWidget extends StatelessWidget {
  const AppointmentsTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      child: SizedBox(
        height: 44,
        child: TabBar(
          padding: const EdgeInsets.all(4),
          indicator: BoxDecoration(
            // color: AppTheme.primaryColor,
            // borderRadius: BorderRadius.circular(AppTheme.radiusMedium - 2),
            border: Border(
              bottom: BorderSide(color: AppTheme.primaryColor2, width: 2),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppTheme.primaryColor2,
          unselectedLabelColor: AppTheme.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
    );
  }
}
