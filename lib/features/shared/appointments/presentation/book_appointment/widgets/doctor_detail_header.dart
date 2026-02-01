import 'package:doctorbooking/features/shared/doctors/data/model/doctor_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'doctor_profile_header_widget.dart';
import 'doctor_stats_widget.dart';

// رأس صفحة تفاصيل الطبيب
class DoctorDetailHeader extends StatelessWidget {
  final DoctorModel doctorModel;
  const DoctorDetailHeader({super.key, required this.doctorModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DoctorProfileHeaderWidget(doctor: doctorModel, onMessageTap: () {}),
        const SizedBox(height: AppTheme.spacing12),
        DoctorStatsWidget(doctor: doctorModel),

        const SizedBox(height: AppTheme.spacing12),
      ],
    );
  }
}
