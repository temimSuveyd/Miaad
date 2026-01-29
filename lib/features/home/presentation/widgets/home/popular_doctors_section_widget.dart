import 'package:doctorbooking/features/shared/doctors/presentation/cubit/doctors_cubit.dart';
import 'package:doctorbooking/features/shared/doctors/presentation/cubit/doctors_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/widgets/error_state_widget.dart';
import 'doctor_card_widget.dart';
import 'doctor_card_shimmer.dart';

class PopularDoctorsSectionWidget extends StatelessWidget {
  const PopularDoctorsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SharedDoctorsCubit>()..loadDoctors(),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الأطباء المشهورون', style: AppTheme.sectionTitle),
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
          const SizedBox(height: AppTheme.spacing16),
          BlocBuilder<SharedDoctorsCubit, DoctorsState>(
            builder: (context, state) {
              if (state is DoctorsLoading) {
                return const DoctorCardsShimmerList(itemCount: 3);
              }

              if (state is DoctorsError) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing16,
                  ),
                  child: ErrorStateWidget(
                    title: 'خطأ في تحميل الأطباء',
                    message: state.message,
                    icon: Icons.local_hospital_rounded,
                    onRetry: () {
                      context.read<SharedDoctorsCubit>().loadDoctors();
                    },
                    retryButtonText: 'إعادة التحميل',
                  ),
                );
              }

              if (state is DoctorsLoaded) {
                final doctors = state.popularDoctors;

                if (doctors.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing16,
                    ),
                    child: const EmptyStateWidget(
                      title: 'لا توجد أطباء',
                      message: 'لا توجد أطباء متاحون في الوقت الحالي',
                      icon: Icons.medical_services_rounded,
                    ),
                  );
                }

                return Column(
                  children: doctors.map((doctor) {
                    return DoctorCardWidget(
                      doctorModel: doctor,
                      showFavorite: true,
                      isFavorite: false,
                      onTap: () {
                        context.read<SharedDoctorsCubit>().goToDoctorDetailsPage(
                          doctorModel: doctor,
                        );
                      },
                    );
                  }).toList(),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
