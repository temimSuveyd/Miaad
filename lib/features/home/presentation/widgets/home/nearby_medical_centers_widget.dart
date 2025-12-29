import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';
import 'package:doctorbooking/features/home/data/mock/mock_doctor_data.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:doctorbooking/features/home/data/models/review_model.dart';
import 'package:doctorbooking/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';

class MedicalCenter {
  final String name;
  final String imageUrl;

  MedicalCenter(this.name, this.imageUrl);
}

class NearbyMedicalCentersWidget extends StatelessWidget {
  const NearbyMedicalCentersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء بيانات وهمية تفصيلية للطبيب
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المراكز الطبية القريبة', style: AppTheme.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            itemCount: MockDoctorData.topDoctors.length,
            itemBuilder: (context, index) {
              final doctor = MockDoctorData.doctor;
              final doctorInfo = MockDoctorData.doctorInfo;
              final cubit = context.read<HomeCubit>();
              return MedicalCenterCard(
                doctorModel: doctor,
                onTap: () => cubit.goToDoctorDetailsPage(
                  doctorInfoModel: doctorInfo,
                  doctorModel: doctor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MedicalCenterCard extends StatelessWidget {
  final DoctorModel doctorModel;
  final Function() onTap;

  const MedicalCenterCard({
    super.key,
    required this.doctorModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: Container(
                width: 280,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(doctorModel.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              doctorModel.name,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
