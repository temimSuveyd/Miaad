import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/appointments_model.dart';
import '../../../data/repositories/appointments_repositories.dart';
import 'home_state.dart';

// Cubit للصفحة الرئيسية
class HomeCubit extends Cubit<HomeState> {
  final AppointmentsRepository repository;

  // معرف المستخدم المؤقت
  static const String tempUserId = '5a4b4fc1-4c58-4d2c-baac-ef050fce8ce3';

  HomeCubit({required this.repository}) : super(HomeInitial());

  // جلب مواعيد المستخدم
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
}
