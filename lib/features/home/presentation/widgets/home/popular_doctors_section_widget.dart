import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../../../core/theme/app_theme.dart';
import 'doctor_card_widget.dart';

class PopularDoctorsSectionWidget extends StatelessWidget {
  const PopularDoctorsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _doctors = [
      {
        'id': 0,
        'name': 'Dr. Randy Wigham',
        'specialty': 'General | RSUD Gatot Subroto',
        'rating': 4.8,
        'reviews': 4279,
        'price': '\$25.00/hr',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'id': 0,

        'name': 'Dr. Jack Suilivan',
        'specialty': 'General | RSUD Gatot Subroto',
        'rating': 4.8,
        'reviews': 4279,
        'price': '\$22.00/hr',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'id': 0,

        'name': 'Dr. Randy Wigham',
        'specialty': 'General | RSUD Gatot Subroto',
        'rating': 4.8,
        'reviews': 4279,
        'price': '\$25.00/hr',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'id': 0,

        'name': 'Dr. Randy Wigham',
        'specialty': 'General | RSUD Gatot Subroto',
        'rating': 4.8,
        'reviews': 4279,
        'price': '\$28.00/hr',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'id': 0,

        'name': 'Dr. Randy Wigham',
        'specialty': 'General | RSUD Gatot Subroto',
        'rating': 4.8,
        'reviews': 4279,
        'price': '\$25.00/hr',
        'imageUrl': 'https://via.placeholder.com/150',
      },
    ];

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الأطباء المشهورون',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'عرض الكل',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
          child: Column(
            children: _doctors.map((doctor) {
              return DoctorCardWidget(
                doctorModel: DoctorModel.fromJson(doctor),
                showFavorite: true,
                isFavorite: false,
                onTap: () {
                  Get.toNamed(AppRoutes.doctorDetail);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
