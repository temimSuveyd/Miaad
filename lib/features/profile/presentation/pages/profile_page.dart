import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppTheme.spacing20),

            // Profile Header with avatar, name, phone
            ProfileHeader(),

            SizedBox(height: AppTheme.spacing32),

            // Menu List
            ProfileMenuList(),

            SizedBox(height: AppTheme.spacing32),
          ],
        ),
      ),
    );
  }
}
