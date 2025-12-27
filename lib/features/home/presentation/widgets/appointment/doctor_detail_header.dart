import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'doctor_profile_header_widget.dart';
import 'doctor_stats_widget.dart';

// رأس صفحة تفاصيل الطبيب
class DoctorDetailHeader extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  final TabController? controller;

  const DoctorDetailHeader({
    super.key,
    required this.doctorData, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppTheme.spacing12),
      child: Column(
        children: [
          DoctorProfileHeaderWidget(
            name: doctorData['name'],
            specialty: doctorData['specialty'],
            hospital: doctorData['hospital'],
            rating: doctorData['rating'],
            reviewCount: doctorData['reviewCount'],
            imageUrl: doctorData['imageUrl'],
            onMessageTap: () {},
          ),
          const SizedBox(height: AppTheme.spacing12),
          DoctorStatsWidget(
            experienceYears: doctorData['experienceYears'],
            patientsCount: doctorData['patientsCount'],
            reviewsCount: doctorData['reviewsCount'],
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: controller,
      labelColor: AppTheme.primaryColor,
      unselectedLabelColor: AppTheme.textSecondary,
      indicatorColor: AppTheme.primaryColor,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      tabs: const [
        Tab(text: 'Schedules'),
        Tab(text: 'About'),
        Tab(text: 'Location'),
        Tab(text: 'Reviews'),
      ],
    );
  }
}
