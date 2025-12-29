import 'package:equatable/equatable.dart';
import '../../../data/models/appointments_model.dart';

// حالات صفحة مواعيدي
abstract class MyAppointmentsState extends Equatable {
  const MyAppointmentsState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class MyAppointmentsInitial extends MyAppointmentsState {
  const MyAppointmentsInitial();
}

// حالة التحميل
class MyAppointmentsLoading extends MyAppointmentsState {
  const MyAppointmentsLoading();
}

// حالة تحميل المواعيد بنجاح
class MyAppointmentsLoaded extends MyAppointmentsState {
  final List<AppointmentsModel> upcomingAppointments;
  final List<AppointmentsModel> completedAppointments;
  final List<AppointmentsModel> cancelledAppointments;

  const MyAppointmentsLoaded({
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
  });

  @override
  List<Object?> get props => [
    upcomingAppointments,
    completedAppointments,
    cancelledAppointments,
  ];
}

// حالة الخطأ
class MyAppointmentsError extends MyAppointmentsState {
  final String message;

  const MyAppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

// حالة إلغاء الموعد
class MyAppointmentCancelling extends MyAppointmentsState {
  final String appointmentId;

  const MyAppointmentCancelling(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

// حالة نجاح إلغاء الموعد
class MyAppointmentCancelled extends MyAppointmentsState {
  final String appointmentId;
  final String message;
  final List<AppointmentsModel> upcomingAppointments;
  final List<AppointmentsModel> completedAppointments;
  final List<AppointmentsModel> cancelledAppointments;

  const MyAppointmentCancelled({
    required this.appointmentId,
    required this.message,
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    message,
    upcomingAppointments,
    completedAppointments,
    cancelledAppointments,
  ];
}

// حالة فشل إلغاء الموعد
class MyAppointmentCancelError extends MyAppointmentsState {
  final String message;
  final List<AppointmentsModel> upcomingAppointments;
  final List<AppointmentsModel> completedAppointments;
  final List<AppointmentsModel> cancelledAppointments;

  const MyAppointmentCancelError({
    required this.message,
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
  });

  @override
  List<Object?> get props => [
    message,
    upcomingAppointments,
    completedAppointments,
    cancelledAppointments,
  ];
}
