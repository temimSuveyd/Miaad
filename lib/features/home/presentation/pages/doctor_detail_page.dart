import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/doctor_model.dart';
import '../../data/mock/mock_doctor_data.dart';
import '../cubit/doctor_detail_cubit/doctor_detail_cubit.dart';
import '../cubit/doctor_detail_cubit/doctor_detail_state.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: DoctorDetailHeader(doctorModel: doctorModel),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),
            SliverToBoxAdapter(
              child: AboutTabWidget(doctorInfoModel: doctorInfoModle),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'التقييمات',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'عرض الكل',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),
            ReviewsTabWidget(reviews: doctorInfoModle.reviews),
            // LocationTabWidget(
            //   practicePlace: doctorInfo['location'],
            //   latitude: doctorInfo['latitude'],
            //   longitude: doctorInfo['longitude'],
            // ),
          ],
        ),
      ),
    );
  }
}
