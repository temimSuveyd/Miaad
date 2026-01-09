import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/doctor_model.dart';
import '../cubit/doctor_details_cubit/doctor_details_cubit.dart';
import '../cubit/doctor_details_cubit/doctor_details_state.dart';
import '../widgets/appointment/doctor_booking_bottom_bar.dart';
import '../widgets/appointment/doctor_detail_header.dart';
import '../widgets/appointment/about_tab_widget.dart';
import '../widgets/appointment/reviews_tab_widget.dart';

// صفحة تفاصيل الطبيب
class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorDetailCubit()..initData(),
      child: const _DoctorDetailPageContent(),
    );
  }
}

// محتوى صفحة تفاصيل الطبيب
class _DoctorDetailPageContent extends StatelessWidget {
  const _DoctorDetailPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
      builder: (context, state) {
        if (state is DoctorDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is DoctorDetailError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is DoctorDetailLoaded) {
          final cubit = context.read<DoctorDetailCubit>();
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: CustomAppBar(title: state.doctor.name, showleading: true),
            body: _buildBody(state.doctor, state.doctorInfo),
            bottomNavigationBar: DoctorBookingBottomBar(
              canBook: true,
              isLoading: false,
              onBookPressed: () =>
                  cubit.goToBookAppointmentPage(doctorModel: state.doctor),
              title: 'حجز موعد',
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('لا توجد بيانات')));
      },
    );
  }

  Widget _buildBody(DoctorModel doctorModel, DoctorInfoModel doctorInfoModle) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing20)),

        // Header Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: DoctorDetailHeader(doctorModel: doctorModel),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // About Section Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: AboutTabWidget(doctorInfoModel: doctorInfoModle),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // Reviews Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('التقييمات', style: AppTheme.sectionTitle),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'عرض الكل',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),

        // Reviews List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
          sliver: ReviewsTabWidget(reviews: doctorInfoModle.reviews),
        ),

        // Bottom Spacing for bottom bar
        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
      ],
    );
  }
}
