import 'package:doctorbooking/features/shared/doctors/data/model/doctor_model.dart';
import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:doctorbooking/features/shared/appointments/data/repositories/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'doctor_details_state.dart';

// Cubit لإدارة حالة صفحة تفاصيل الطبيب
class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  DoctorDetailCubit({required this.repository}) : super(const DoctorDetailInitial());

  final SharedAppointmentRepository repository;
  late DoctorModel doctorModel;
  late DoctorInfoModel doctorInfoModel;

  initData() {
    doctorModel = Get.arguments['doctor_model'];
    doctorInfoModel = Get.arguments['doctor_info_model'];
    emit(DoctorDetailLoaded(doctor: doctorModel, doctorInfo: doctorInfoModel));
    // Load schedules after initial data is loaded
    loadDoctorSchedules();
  }

  /// تحميل جدول عمل الطبيب
  Future<void> loadDoctorSchedules() async {
    if (state is! DoctorDetailLoaded) return;

    final currentState = state as DoctorDetailLoaded;
    
    // Start loading
    emit(currentState.copyWith(isLoadingSchedules: true, scheduleError: null));

    try {
      // Get real data from backend
      final schedules = await repository.getDoctorSchedules(doctorModel.id);
      
      emit(currentState.copyWith(
        schedules: schedules,
        isLoadingSchedules: false,
        scheduleError: null,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isLoadingSchedules: false,
        scheduleError: 'فشل في تحميل جدول العمل: $e',
      ));
    }
  }

  void goToBookAppointmentPage( {required DoctorModel doctorModel , }) {
    Get.toNamed(
      AppRoutes.bookApptintment,
      arguments: {'doctor_model': doctorModel},
    );
  }

  // إضافة تعليق (سيتم تنفيذه لاحقاً)
  Future<void> addReview({
    required String comment,
    required double rating,
  }) async {
    // TODO: تنفيذ إضافة التعليق لاحقاً
  }

  // تحديث حالة المفضلة (سيتم تنفيذه لاحقاً)
  Future<void> toggleFavorite() async {
    // TODO: تنفيذ إضافة/إزالة من المفضلة لاحقاً
  }
}
