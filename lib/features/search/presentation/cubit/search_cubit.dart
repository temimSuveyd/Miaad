import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/search_repository.dart';
import 'search_state.dart';

// Cubit للبحث عن الأطباء
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;
  Timer? _debounceTimer;

  // مدة التأخير للبحث
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  SearchCubit({required this.repository}) : super(SearchInitial());

  // تحميل جميع الأطباء في البداية
  Future<void> loadAllDoctors() async {
    emit(SearchLoading());

    final result = await repository.getAllDoctors();

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: 'جميع الأطباء'));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: 'جميع الأطباء'));
      }
    });
  }

  // البحث عن الأطباء مع التأخير
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

  // تنفيذ البحث الفعلي
  Future<void> _performSearch(String query) async {
    emit(SearchLoading());

    final result = await repository.searchDoctors(query);

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: query));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: query));
      }
    });
  }

  // البحث الفوري بدون تأخير
  Future<void> searchDoctorsInstant(String query) async {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      await loadAllDoctors();
      return;
    }

    await _performSearch(query.trim());
  }

  // البحث حسب التخصص
  Future<void> searchBySpecialty(String specialty) async {
    _debounceTimer?.cancel();
    emit(SearchLoading());

    final result = await repository.getDoctorsBySpecialty(specialty);

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: specialty));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: specialty));
      }
    });
  }

  // البحث حسب الموقع
  Future<void> searchByLocation(String location) async {
    _debounceTimer?.cancel();
    emit(SearchLoading());

    final result = await repository.searchDoctorsByLocation(location);

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: location));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: location));
      }
    });
  }

  // البحث حسب المستشفى
  Future<void> searchByHospital(String hospital) async {
    _debounceTimer?.cancel();
    emit(SearchLoading());

    final result = await repository.searchDoctorsByHospital(hospital);

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: hospital));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: hospital));
      }
    });
  }

  // مسح البحث
  void clearSearch() {
    _debounceTimer?.cancel();
    loadAllDoctors();
  }

  // إعادة المحاولة
  void retry(String query) {
    if (query.trim().isNotEmpty) {
      searchDoctorsInstant(query);
    } else {
      loadAllDoctors();
    }
  }

  // البحث بالفلترة المتقدمة
  Future<void> searchWithFilters({
    required String query,
    String? specialty,
    String? location,
    String? hospital,
  }) async {
    _debounceTimer?.cancel();
    emit(SearchLoading());

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
    final result = await repository.searchDoctors(query);

    result.fold((failure) => emit(SearchError(failure.message)), (doctors) {
      if (doctors.isEmpty) {
        emit(SearchEmpty(query: query));
      } else {
        emit(SearchLoaded(searchResults: doctors, query: query));
      }
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
