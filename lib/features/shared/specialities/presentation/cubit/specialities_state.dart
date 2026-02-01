import 'package:equatable/equatable.dart';
import '../../data/model/speciality_model.dart';

abstract class SpecialitiesState extends Equatable {
  const SpecialitiesState();

  @override
  List<Object?> get props => [];
}

class SpecialitiesInitial extends SpecialitiesState {}

class SpecialitiesLoading extends SpecialitiesState {}

class SpecialitiesLoaded extends SpecialitiesState {
  final List<SpecialityModel> specialities;

  const SpecialitiesLoaded({required this.specialities});

  @override
  List<Object?> get props => [specialities];
}

class SpecialitiesError extends SpecialitiesState {
  final String message;

  const SpecialitiesError(this.message);

  @override
  List<Object?> get props => [message];
}
