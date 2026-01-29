import 'package:equatable/equatable.dart';
import '../../../../../core/models/models.dart';

/// حالات الصفحة الرئيسية
/// Home Page States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class HomeInitial extends HomeState {}

/// حالة التحميل
class HomeLoading extends HomeState {}

/// حالة نجاح تحميل المواعيد
class HomeAppointmentsLoaded extends HomeState {
  final List<AppointmentModel> appointments;
  final List<AppointmentModel> upcomingAppointments;
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

  /// إجمالي عدد المواعيد
  int get totalAppointments => appointments.length;

  /// المواعيد المكتملة
  List<AppointmentModel> get completedAppointments => appointments
      .where((apt) => apt.status == AppointmentStatus.completed)
      .toList();

  /// المواعيد الملغية
  List<AppointmentModel> get cancelledAppointments => appointments
      .where((apt) => apt.status == AppointmentStatus.cancelled)
      .toList();
}

/// حالة تحميل المواعيد القادمة فقط
class HomeUpcomingAppointmentsLoaded extends HomeState {
  final List<AppointmentModel> upcomingAppointments;
  final int upcomingCount;
  final bool hasUpcomingAppointments;

  const HomeUpcomingAppointmentsLoaded({
    required this.upcomingAppointments,
    required this.upcomingCount,
    required this.hasUpcomingAppointments,
  });

  @override
  List<Object?> get props => [
    upcomingAppointments,
    upcomingCount,
    hasUpcomingAppointments,
  ];
}

/// حالة عدم وجود مواعيد
class HomeNoAppointments extends HomeState {
  const HomeNoAppointments();
}

/// حالة الخطأ
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
