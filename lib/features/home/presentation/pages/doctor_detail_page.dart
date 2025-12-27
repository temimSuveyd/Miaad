import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/service_locator.dart';
import '../../data/mock/mock_doctor_data.dart';
import '../cubit/appointment_cubit/appointments_cubit.dart';
import '../cubit/appointment_cubit/appointments_state.dart';
import '../widgets/appointment/appointments_state_listener.dart';
import '../widgets/appointment/booking_confirmation_dialog.dart';
import '../widgets/appointment/doctor_booking_bottom_bar.dart';
import '../widgets/appointment/doctor_detail_header.dart';
import '../widgets/appointment/about_tab_widget.dart';
import '../widgets/appointment/location_tab_widget.dart';
import '../widgets/appointment/reviews_tab_widget.dart';
import '../widgets/appointment/schedules_tab_widget.dart';

// صفحة تفاصيل الطبيب
class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsCubit>(),
      child: const _DoctorDetailPageContent(),
    );
  }
}

// محتوى صفحة تفاصيل الطبيب
class _DoctorDetailPageContent extends StatefulWidget {
  const _DoctorDetailPageContent();

  @override
  State<_DoctorDetailPageContent> createState() =>
      _DoctorDetailPageContentState();
}

class _DoctorDetailPageContentState extends State<_DoctorDetailPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppointmentsStateListener(
      doctorName: MockDoctorData.doctor.name,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: CustomAppBar(title: MockDoctorData.doctor.name),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: DoctorDetailHeader(
              doctorData: MockDoctorData.doctorInfo,
              controller: _tabController,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          SchedulesTabWidget(
            onScheduleSelected: (date, time) {
              context.read<AppointmentsCubit>().selectDateTime(
                date: date,
                time: time,
              );
            },
          ),
          AboutTabWidget(
            aboutText: MockDoctorData.doctorInfo['aboutText'],
            workingTime: MockDoctorData.doctorInfo['workingTime'],
            strNumber: MockDoctorData.doctorInfo['strNumber'],
            practicePlace: MockDoctorData.doctorInfo['practicePlace'],
            practiceYears: MockDoctorData.doctorInfo['practiceYears'],
          ),
          LocationTabWidget(
            practicePlace: MockDoctorData.doctorInfo['location'],
            latitude: MockDoctorData.doctorInfo['latitude'],
            longitude: MockDoctorData.doctorInfo['longitude'],
          ),
          ReviewsTabWidget(reviews: MockDoctorData.reviews),
        ],
      ),
    );
  }

  // بناء الشريط السفلي
  Widget _buildBottomBar() {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentsCubit>();
        return DoctorBookingBottomBar(
          canBook: cubit.canBook(),
          isLoading: cubit.isLoading(),
          onBookPressed: () => _showBookingDialog(context, state),
          onMessagePressed: () {
            // TODO: تنفيذ وظيفة الرسائل
          },
        );
      },
    );
  }

  // عرض حوار الحجز
  void _showBookingDialog(BuildContext context, AppointmentsState state) {
    if (state is! AppointmentDateTimeSelected) return;

    BookingConfirmationDialog.show(
      context,
      doctorName: MockDoctorData.doctor.name,
      selectedDate: state.selectedDate!,
      selectedTime: state.selectedTime!,
      userId: MockDoctorData.userId,
      doctorId: MockDoctorData.doctorId,
      onConfirm: () {
        context.read<AppointmentsCubit>().createAppointment(
          userId: MockDoctorData.userId,
          doctorId: MockDoctorData.doctorId,
          notes: 'Appointment with ${MockDoctorData.doctor.name}',
        );
      },
    );
  }
}
