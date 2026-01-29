import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/doctors/data/repositories/doctors_repository.dart';
import '../../../shared/doctors/presentation/cubit/doctors_state.dart';

/// Search Cubit - يستخدم SharedDoctorsRepository للبحث
class SearchCubit extends Cubit<DoctorsState> {
  final SharedDoctorsRepository _repository;
  Timer? _debounceTimer;

  // مدة التأخير للبحث
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  SearchCubit({required SharedDoctorsRepository repository})
    : _repository = repository,
      super(DoctorsInitial());

  /// تحميل جميع الأطباء في البداية
  Future<void> loadAllDoctors() async {
    emit(DoctorsLoading());

    final result = await _repository.getAllDoctors();

    result.fold((failure) => emit(DoctorsError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(DoctorsSearchEmpty(query: 'جميع الأطباء'));
      } else {
        emit(DoctorsLoaded(doctors: doctors, popularDoctors: []));
      }
    });
  }

  /// البحث عن الأطباء مع التأخير (Debounced Search)
  void searchDoctors(String query) {
    // إلغاء المؤقت السابق
    _debounceTimer?.cancel();

    // إذا كان البحث فارغ، تحميل جميع الأطباء
    if (query.trim().isEmpty) {
      loadAllDoctors();
      return;
    }

    // بدء مؤقت جديد للبحث المتأخر
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query.trim());
    });
  }

  /// البحث الفوري بدون تأخير
  Future<void> searchDoctorsInstant(String query) async {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      await loadAllDoctors();
      return;
    }

    await _performSearch(query.trim());
  }

  /// تنفيذ البحث الفعلي
  Future<void> _performSearch(String query) async {
    emit(DoctorsLoading());

    final result = await _repository.searchDoctors(query);

    result.fold((failure) => emit(DoctorsError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(DoctorsSearchEmpty(query: query));
      } else {
        emit(DoctorsSearchLoaded(searchResults: doctors, query: query));
      }
    });
  }

  /// البحث حسب التخصص
  Future<void> searchBySpecialty(String specialty) async {
    _debounceTimer?.cancel();
    emit(DoctorsLoading());

    final result = await _repository.getDoctorsBySpecialty(specialty);

    result.fold((failure) => emit(DoctorsError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(DoctorsSearchEmpty(query: specialty));
      } else {
        emit(DoctorsSearchLoaded(searchResults: doctors, query: specialty));
      }
    });
  }

  /// البحث حسب الموقع
  Future<void> searchByLocation(String location) async {
    _debounceTimer?.cancel();
    emit(DoctorsLoading());

    final result = await _repository.searchDoctorsByLocation(location);

    result.fold((failure) => emit(DoctorsError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(DoctorsSearchEmpty(query: location));
      } else {
        emit(DoctorsSearchLoaded(searchResults: doctors, query: location));
      }
    });
  }

  /// البحث حسب المستشفى
  Future<void> searchByHospital(String hospital) async {
    _debounceTimer?.cancel();
    emit(DoctorsLoading());

    final result = await _repository.searchDoctorsByHospital(hospital);

    result.fold((failure) => emit(DoctorsError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(DoctorsSearchEmpty(query: hospital));
      } else {
        emit(DoctorsSearchLoaded(searchResults: doctors, query: hospital));
      }
    });
  }

  /// البحث بالفلترة المتقدمة
  Future<void> searchWithFilters({
    required String query,
    String? specialty,
    String? location,
    String? hospital,
  }) async {
    _debounceTimer?.cancel();
    emit(DoctorsLoading());

    // إذا كان هناك فلتر محدد، استخدم البحث المخصص
    if (specialty != null && specialty.isNotEmpty) {
      await searchBySpecialty(specialty);
      return;
    }

    if (location != null && location.isNotEmpty) {
      await searchByLocation(location);
      return;
    }

    if (hospital != null && hospital.isNotEmpty) {
      await searchByHospital(hospital);
      return;
    }

    // إذا لم يكن هناك فلتر محدد، استخدم البحث العام
    await _performSearch(query);
  }

  /// مسح البحث والعودة لجميع الأطباء
  void clearSearch() {
    _debounceTimer?.cancel();
    loadAllDoctors();
  }

  /// إعادة المحاولة
  void retry(String query) {
    if (query.trim().isNotEmpty) {
      searchDoctorsInstant(query);
    } else {
      loadAllDoctors();
    }
  }

  /// تحديث حالة البحث بدون إجراء بحث جديد
  void updateSearchQuery(String query) {
    // يمكن استخدامها لتحديث UI فقط
    if (state is DoctorsSearchLoaded) {
      final currentState = state as DoctorsSearchLoaded;
      emit(
        DoctorsSearchLoaded(
          searchResults: currentState.searchResults,
          query: query,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
