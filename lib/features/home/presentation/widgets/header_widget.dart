import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(
              Icons.notifications_none,
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}