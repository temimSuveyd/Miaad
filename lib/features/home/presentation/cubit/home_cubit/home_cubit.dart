import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/models/models.dart';
import '../../../../../core/routing/presentation/routes/app_routes.dart';
import '../../../../../core/services/user_service.dart';
import '../../../../shared/appointments/data/repositories/appointment_repository.dart';
import '../../../data/models/doctor_info_model.dart';
import 'home_state.dart';

/// Cubit للصفحة الرئيسية
/// Home Page State Management
class HomeCubit extends Cubit<HomeState> {
  final SharedAppointmentRepository _repository;

  // معرف المستخدم المؤقت
  // static const String tempUserId = '5a4b4fc1-4c58-4d2c-baac-ef050fce8ce3';
  String? _currentUserId;

  // Stream subscription للاستماع للتحديثات
  StreamSubscription? _appointmentsSubscription;

  HomeCubit({required SharedAppointmentRepository repository})
    : _repository = repository,
      super(HomeInitial()) {
    _loadUserId();
  }

  /// تحميل معرف المستخدم الحالي
  Future<void> _loadUserId() async {
    try {
      _currentUserId = await UserService.getCurrentUserId();
      // بعد تحميل معرف المستخدم، ابدأ تحميل المواعيد
      if (_currentUserId != null) {
        subscribeToUserAppointments();
      } else {
        emit(HomeError('User not logged in'));
      }
    } catch (e) {
      emit(HomeError('Failed to load user ID'));
    }
  }

  /// جلب مواعيد المستخدم (مرة واحدة)
  Future<void> fetchUserAppointments() async {
    if (_currentUserId == null) {
      emit(HomeError('User not logged in'));
      return;
    }
    
    emit(HomeLoading());

    final result = await _repository.getUserAppointments(_currentUserId!);

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

  /// الاستماع لمواعيد المستخدم بشكل real-time
  Future<void> subscribeToUserAppointments() async {
    if (_currentUserId == null) {
      await _loadUserId();
    }
    
    if (_currentUserId == null) {
      emit(HomeError('User not logged in'));
      return;
    }
    
    emit(HomeLoading());

    // إلغاء الاشتراك السابق إن وجد
    _appointmentsSubscription?.cancel();

    _appointmentsSubscription = _repository
        .getUserAppointmentsStream(_currentUserId!)
        .listen(
          (result) {
            result.fold(
              (failure) {
                emit(HomeError(failure.message));
              },
              (appointments) {
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

  /// جلب المواعيد القادمة فقط
  Future<void> fetchUpcomingAppointments() async {
    if (_currentUserId == null) {
      await _loadUserId();
    }
    
    if (_currentUserId == null) {
      emit(HomeError('User not logged in'));
      return;
    }
    
    emit(HomeLoading());

    final result = await _repository.getUpcomingAppointments(_currentUserId!);

    result.fold((failure) => emit(HomeError(failure.message)), (appointments) {
      emit(
        HomeUpcomingAppointmentsLoaded(
          upcomingAppointments: appointments,
          upcomingCount: appointments.length,
          hasUpcomingAppointments: appointments.isNotEmpty,
        ),
      );
    });
  }

  /// إعادة تحميل المواعيد
  Future<void> refreshAppointments() async {
    await _loadUserId();
  }

  /// إعادة المحاولة
  Future<void> retry() async {
    await _loadUserId();
  }

  /// تصفية المواعيد القادمة
  List<AppointmentModel> _filterUpcomingAppointments(
    List<AppointmentModel> appointments,
  ) {
    return appointments
        .where(
          (apt) =>
              apt.status == AppointmentStatus.upcoming ||
              apt.status == AppointmentStatus.rescheduled,
        )
        .toList();
  }

  /// الانتقال إلى صفحة تفاصيل الطبيب
  void goToDoctorDetailsPage({
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

  /// الانتقال إلى صفحة جميع المواعيد
  void goToMyAppointmentsPage() {
    Get.toNamed(AppRoutes.appointment);
  }

  /// الانتقال إلى صفحة حجز موعد
  void goToBookAppointmentPage(DoctorModel doctorModel) {
    Get.toNamed(
      AppRoutes.bookApptintment,
      arguments: {'doctor_model': doctorModel},
    );
  }

  @override
  Future<void> close() {
    _appointmentsSubscription?.cancel();
    return super.close();
  }
}
