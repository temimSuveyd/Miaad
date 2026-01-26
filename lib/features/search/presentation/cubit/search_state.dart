import 'package:doctorbooking/core/models/doctor_model.dart';
import 'package:equatable/equatable.dart';

// حالات البحث
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class SearchInitial extends SearchState {}

// حالة التحميل
class SearchLoading extends SearchState {}

// حالة نجاح البحث
class SearchLoaded extends SearchState {
  final List<DoctorModel> searchResults;
  final String query;

  const SearchLoaded({required this.searchResults, required this.query});

  @override
  List<Object?> get props => [searchResults, query];
}

// حالة البحث الفارغ
class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

// حالة الخطأ
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
