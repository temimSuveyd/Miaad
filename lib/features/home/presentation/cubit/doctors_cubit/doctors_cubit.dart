import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/models/doctor_model.dart';
import '../../../../../core/routing/presentation/routes/app_routes.dart';
import '../../../../../core/utils/working_hours_parser.dart';
import '../../../data/models/doctor_info_model.dart';
import '../../../data/repositories/doctors_repository.dart';
import 'doctors_state.dart';

// Cubit للأطباء
class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepository repository;

  DoctorsCubit({required this.repository}) : super(DoctorsInitial());

  // جلب جميع الأطباء والأطباء المشهورين
  Future<void> loadDoctors() async {
    emit(DoctorsLoading());

    try {
      // جلب الأطباء المشهورين
      final popularResult = await repository.getPopularDoctors(limit: 5);

      // جلب جميع الأطباء
      final allResult = await repository.getAllDoctors();

      // التحقق من النتائج
      if (popularResult.isLeft() || allResult.isLeft()) {
        final error = popularResult.fold(
          (failure) => failure.message,
          (_) => allResult.fold(
            (failure) => failure.message,
            (_) => 'خطأ غير متوقع',
          ),
        );
        emit(DoctorsError(error));
        return;
      }

      // استخراج البيانات
      final popularDoctors = popularResult.fold(
        (_) => <DoctorModel>[],
        (doctors) => doctors,
      );

      final allDoctors = allResult.fold(
        (_) => <DoctorModel>[],
        (doctors) => doctors,
      );

      emit(DoctorsLoaded(doctors: allDoctors, popularDoctors: popularDoctors));
    } catch (e) {
      emit(DoctorsError('خطأ في تحميل الأطباء: $e'));
    }
  }

  // البحث عن الأطباء
  Future<void> searchDoctors(String query) async {
    if (query.trim().isEmpty) {
      loadDoctors();
      return;
    }

    emit(DoctorsLoading());

    final result = await repository.searchDoctors(query);

    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) =>
          emit(DoctorsSearchLoaded(searchResults: doctors, query: query)),
    );
  }

  // الحصول على الأطباء حسب التخصص
  Future<void> getDoctorsBySpecialty(String specialty) async {
    emit(DoctorsLoading());

    final result = await repository.getDoctorsBySpecialty(specialty);

    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) =>
          emit(DoctorsSearchLoaded(searchResults: doctors, query: specialty)),
    );
  }

  // الانتقال إلى صفحة تفاصيل الطبيب
  void goToDoctorDetailsPage({required DoctorModel doctorModel}) {
    // إنشاء معلومات الطبيب من البيانات المتاحة
    final doctorInfoModel = DoctorInfoModel(
      aboutText: doctorModel.experience,
      workingTime: WorkingHoursParser.formatWorkingHoursAsMap(
        doctorModel.workingHours,
      ),
      strNumber: doctorModel.id.substring(0, 8),
      practicePlace: doctorModel.hospital,
      practiceYears: _extractYearsFromExperience(doctorModel.experience),
      location: doctorModel.location,
      latitude: 0.0, // Default coordinates
      longitude: 0.0,
    );

    Get.toNamed(
      AppRoutes.doctorDetail,
      arguments: {
        'doctor_model': doctorModel,
        'doctor_info_model': doctorInfoModel,
      },
    );
  }

  // استخراج سنوات الخبرة
  String _extractYearsFromExperience(String? experience) {
    if (experience == null) return 'غير محدد';

    // البحث عن رقم في النص
    final RegExp yearRegex = RegExp(r'(\d+)');
    final match = yearRegex.firstMatch(experience);

    if (match != null) {
      final years = int.parse(match.group(1)!);
      final startYear = DateTime.now().year - years;
      return '$startYear - الحاضر';
    }

    return 'غير محدد';
  }
}
