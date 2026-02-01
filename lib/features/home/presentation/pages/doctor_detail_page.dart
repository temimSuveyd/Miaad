import 'package:doctorbooking/features/shared/doctors/data/model/doctor_model.dart';
import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/doctor_details_cubit/doctor_details_cubit.dart';
import '../cubit/doctor_details_cubit/doctor_details_state.dart';
import '../../../reviews/presentation/cubit/reviews_cubit.dart';
import '../../../shared/appointments/presentation/book_appointment/widgets/doctor_booking_bottom_bar.dart';
import '../../../shared/appointments/presentation/book_appointment/widgets/doctor_detail_header.dart';
import '../../../shared/appointments/presentation/book_appointment/widgets/about_tab_widget.dart';
import '../widgets/reviews/reviews_section.dart';
import '../widgets/reviews/add_review_card.dart';
import '../widgets/doctor_schedule_widget.dart';

// صفحة تفاصيل الطبيب
class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<DoctorDetailCubit>()..initData()),
        BlocProvider(create: (context) => sl<ReviewsCubit>()),
      ],
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

          // تحميل التقييمات عند تحميل بيانات الطبيب
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ReviewsCubit>().loadDoctorReviews(state.doctor.id);
          });

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: CustomAppBar(title: state.doctor.name, showleading: true),
            body: _buildBody(state),
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

  Widget _buildBody(DoctorDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing20)),

        // قسم الرأس
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: DoctorDetailHeader(doctorModel: state.doctor),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // قسم جدول العمل
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: DoctorScheduleWidget(
              schedules: state.schedules,
              isLoading: state.isLoadingSchedules,
              errorMessage: state.scheduleError,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // قسم حول الطبيب
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: AboutTabWidget(doctorInfoModel: state.doctorInfo),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // بطاقة إضافة التقييم
        SliverToBoxAdapter(
          child: AddReviewCard(
            doctorId: state.doctor.id,
            doctorName: state.doctor.name,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // قسم التقييمات
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: ReviewsSection(doctorId: state.doctor.id),
          ),
        ),

        // مساحة إضافية للشريط السفلي
        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
      ],
    );
  }
}
