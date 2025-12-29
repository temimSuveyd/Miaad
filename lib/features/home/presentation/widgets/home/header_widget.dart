import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../pages/my_appointments_page.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Rakib',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                'Good Morning',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              // زر الانتقال إلى صفحة مواعيدي
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAppointmentsPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryColor2,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
