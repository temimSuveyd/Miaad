import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/mock/mock_user_data.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockUserData.currentUser;

    return Column(
      children: [
        // User Name
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: AppTheme.spacing8),

        // Phone Number
        Text(
          user.phone,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
