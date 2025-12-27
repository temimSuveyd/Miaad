import 'package:equatable/equatable.dart';
import '../../../data/models/appointments_model.dart';

// حالات الصفحة الرئيسية
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class HomeInitial extends HomeState {}

// حالة التحميل
class HomeLoading extends HomeState {}

// حالة نجاح تحميل المواعيد
class HomeAppointmentsLoaded extends HomeState {
  final List<AppointmentsModel> appointments;
  final List<AppointmentsModel> upcomingAppointments;
  final int upcomingCount;
  final bool hasUpcomingAppointments;

  const HomeAppointmentsLoaded({
    required this.appointments,
    required this.upcomingAppointments,
    required this.upcomingCount,
    required this.hasUpcomingAppointments,
  });

  @override
  List<Object?> get props => [
    appointments,
    upcomingAppointments,
    upcomingCount,
    hasUpcomingAppointments,
  ];
}

// حالة الخطأ
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
