import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/models/models.dart';
import '../../../../../core/routing/presentation/routes/app_routes.dart';
import '../../../../../core/utils/working_hours_parser.dart';
import '../../../../home/data/models/doctor_info_model.dart';
import '../../data/repositories/doctors_repository.dart';
import 'doctors_state.dart';

// Cubit للأطباء المشترك
class SharedDoctorsCubit extends Cubit<DoctorsState> {
  final SharedDoctorsRepository repository;

  SharedDoctorsCubit({required this.repository}) : super(DoctorsInitial());

  // جلب جميع الأطباء والأطباء المشهورين
  Future<void> loadPopularDoctors() async {
    emit(DoctorsLoading());

    try {
      // جلب الأطباء المشهورين
      final popularResult = await repository.getPopularDoctors(limit: 5);
      // استخراج البيانات
    popularResult.fold(
        (failure) {
      emit(DoctorsError(failure.message));
        },
        (doctors) {
          emit(DoctorsLoaded(doctors: doctors, popularDoctors: doctors));
        }
      );
 
    } catch (e) {
      emit(DoctorsError('خطأ في تحميل الأطباء: $e'));
    }
  }

  // البحث عن الأطباء
  Future<void> searchDoctors(String query) async {
    if (query.trim().isEmpty) {
      loadPopularDoctors();
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

  // البحث حسب الموقع
  Future<void> searchDoctorsByLocation(String location) async {
    emit(DoctorsLoading());

    final result = await repository.searchDoctorsByLocation(location);

    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) =>
          emit(DoctorsSearchLoaded(searchResults: doctors, query: location)),
    );
  }

  // البحث حسب المستشفى
  Future<void> searchDoctorsByHospital(String hospital) async {
    emit(DoctorsLoading());

    final result = await repository.searchDoctorsByHospital(hospital);

    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) =>
          emit(DoctorsSearchLoaded(searchResults: doctors, query: hospital)),
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
