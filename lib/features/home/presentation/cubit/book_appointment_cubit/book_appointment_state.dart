import 'package:doctorbooking/features/home/data/models/appointments_model.dart';
import 'package:equatable/equatable.dart';

// حالات المواعيد
abstract class BookAppointmentState extends Equatable {
  const BookAppointmentState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class BookAppointmentInitial extends BookAppointmentState {}

// جاري التحميل
class BookAppointmentLoading extends BookAppointmentState {}

// نجح إنشاء الموعد
class AppointmentCreated extends BookAppointmentState {
  final AppointmentsModel appointment;

  const AppointmentCreated(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

// فشل العملية
class BookAppointmentError extends BookAppointmentState {
  final String message;

  const BookAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

// تم تحديد التاريخ والوقت
class AppointmentDateTimeSelected extends BookAppointmentState {
  final DateTime? selectedDate;
  final String? selectedTime;

  const AppointmentDateTimeSelected({this.selectedDate, this.selectedTime});

  @override
  List<Object?> get props => [selectedDate, selectedTime];

  bool get canBook => selectedDate != null && selectedTime != null;
}
