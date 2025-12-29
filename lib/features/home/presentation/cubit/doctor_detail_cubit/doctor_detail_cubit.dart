import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'doctor_detail_state.dart';

// Cubit لإدارة حالة صفحة تفاصيل الطبيب
class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  DoctorDetailCubit() : super(const DoctorDetailInitial());

  late DoctorModel doctorModel;
  late DoctorInfoModel doctorInfoModel;

  initData() {
    doctorModel = Get.arguments['doctor_model'];
    doctorInfoModel = Get.arguments['doctor_info_model'];
    emit(DoctorDetailLoaded(doctor: doctorModel, doctorInfo: doctorInfoModel));
  }

  void goToBookAppointmentPage({required DoctorModel doctorModel}) {
    Get.toNamed(
      AppRoutes.appointment,
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
