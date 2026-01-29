import 'package:equatable/equatable.dart';
import '../../../../../core/models/models.dart';

// حالات الأطباء المشتركة
abstract class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class DoctorsInitial extends DoctorsState {}

// حالة التحميل
class DoctorsLoading extends DoctorsState {}

// حالة تحميل الأطباء بنجاح
class DoctorsLoaded extends DoctorsState {
  final List<DoctorModel> doctors;
  final List<DoctorModel> popularDoctors;

  const DoctorsLoaded({required this.doctors, required this.popularDoctors});

  @override
  List<Object?> get props => [doctors, popularDoctors];
}

// حالة نتائج البحث
class DoctorsSearchLoaded extends DoctorsState {
  final List<DoctorModel> searchResults;
  final String query;

  const DoctorsSearchLoaded({required this.searchResults, required this.query});

  @override
  List<Object?> get props => [searchResults, query];
}

// حالة البحث الفارغ
class DoctorsSearchEmpty extends DoctorsState {
  final String query;

  const DoctorsSearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

// حالة الخطأ
class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
