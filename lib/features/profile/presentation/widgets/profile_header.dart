import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'profile_avatar.dart';
import 'profile_info.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Profile Avatar with edit button
        ProfileAvatar(),

        SizedBox(height: AppTheme.spacing20),

        // Name and Phone Info
        ProfileInfo(),
      ],
    );
  }
}
