import 'dart:async';
import 'dart:developer';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../data/models/appointments_model.dart';
import '../../../data/repositories/appointments_repositories.dart';
import 'home_state.dart';

// Cubit للصفحة الرئيسية
class HomeCubit extends Cubit<HomeState> {
  final AppointmentsRepository repository;

  // معرف المستخدم المؤقت
  static const String tempUserId = '5a4b4fc1-4c58-4d2c-baac-ef050fce8ce3';

  // Stream subscription للاستماع للتحديثات
  StreamSubscription? _appointmentsSubscription;

  HomeCubit({required this.repository}) : super(HomeInitial());

  // جلب مواعيد المستخدم (مرة واحدة)
  Future<void> fetchUserAppointments() async {
    emit(HomeLoading());

    final result = await repository.getUserAppointments(tempUserId);

    result.fold((failure) => emit(HomeError(failure.message)), (appointments) {
      // تصفية المواعيد القادمة
      final upcomingAppointments = _filterUpcomingAppointments(appointments);

      emit(
        HomeAppointmentsLoaded(
          appointments: appointments,
          upcomingAppointments: upcomingAppointments,
          upcomingCount: upcomingAppointments.length,
          hasUpcomingAppointments: upcomingAppointments.isNotEmpty,
        ),
      );
    });
  }

  // الاستماع لمواعيد المستخدم بشكل real-time
  void subscribeToUserAppointments() {
    emit(HomeLoading());

    // Eski subscription varsa iptal et
    _appointmentsSubscription?.cancel();

    _appointmentsSubscription = repository
        .getUserAppointmentsStream(tempUserId)
        .listen(
          (result) {
            result.fold(
              (failure) {
                emit(HomeError(failure.message));
              },
              (appointments) {
                log("Realtime appointments: $appointments");
                final upcomingAppointments = _filterUpcomingAppointments(
                  appointments,
                );

                emit(
                  HomeAppointmentsLoaded(
                    appointments: appointments,
                    upcomingAppointments: upcomingAppointments,
                    upcomingCount: upcomingAppointments.length,
                    hasUpcomingAppointments: upcomingAppointments.isNotEmpty,
                  ),
                );
              },
            );
          },
          onError: (error) {
            emit(HomeError('خطأ في الاتصال: $error'));
          },
        );
  }

  // إلغاء الاشتراك
  void unsubscribeFromAppointments() {
    _appointmentsSubscription?.cancel();
    _appointmentsSubscription = null;
  }

  // إعادة تحميل المواعيد
  Future<void> refreshAppointments() async {
    await fetchUserAppointments();
  }

  // تصفية المواعيد القادمة
  List<AppointmentsModel> _filterUpcomingAppointments(
    List<AppointmentsModel> appointments,
  ) {
    return appointments
        .where(
          (apt) =>
              apt.status == AppointmentStatus.upcoming ||
              apt.status == AppointmentStatus.rescheduled,
        )
        .toList();
  }

  @override
  Future<void> close() {
    _appointmentsSubscription?.cancel();
    return super.close();
  }

  goToDoctorDetailsPage({
    required DoctorModel doctorModel,
    required DoctorInfoModel doctorInfoModel,
  }) {
    Get.toNamed(
      AppRoutes.doctorDetail,
      arguments: {
        'doctor_model': doctorModel,
        'doctor_info_model': doctorInfoModel,
      },
    );
  }
}
