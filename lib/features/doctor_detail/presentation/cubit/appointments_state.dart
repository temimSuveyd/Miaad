import 'package:equatable/equatable.dart';
import '../../data/models/appointments_model.dart';

// حالات المواعيد
abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class AppointmentsInitial extends AppointmentsState {}

// جاري التحميل
class AppointmentsLoading extends AppointmentsState {}

// نجح إنشاء الموعد
class AppointmentCreated extends AppointmentsState {
  final AppointmentsModel appointment;

  const AppointmentCreated(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

// فشل العملية
class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

// تم تحديد التاريخ والوقت
class AppointmentDateTimeSelected extends AppointmentsState {
  final DateTime? selectedDate;
  final String? selectedTime;

  const AppointmentDateTimeSelected({this.selectedDate, this.selectedTime});

  @override
  List<Object?> get props => [selectedDate, selectedTime];

  bool get canBook => selectedDate != null && selectedTime != null;
}
