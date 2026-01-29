import 'package:equatable/equatable.dart';
import '../../../../appointments/data/models/appointment.dart';

abstract class AppointmentDetailsState extends Equatable {
  final AppointmentModel appointment;

  const AppointmentDetailsState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

// Initial state
class AppointmentDetailsInitial extends AppointmentDetailsState {
  const AppointmentDetailsInitial({required super.appointment});
}

// Cancel states
class AppointmentDetailsCancelling extends AppointmentDetailsState {
  const AppointmentDetailsCancelling({required super.appointment});
}

class AppointmentDetailsCancelled extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsCancelled({
    required super.appointment,
    required this.message,
  });

  @override
  List<Object?> get props => [appointment, message];
}

class AppointmentDetailsCancelError extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsCancelError({
    required super.appointment,
    required this.message,
  });

  @override
  List<Object?> get props => [appointment, message];
}

// Reschedule states
class AppointmentDetailsRescheduling extends AppointmentDetailsState {
  const AppointmentDetailsRescheduling({required super.appointment});
}

class AppointmentDetailsRescheduled extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsRescheduled({
    required super.appointment,
    required this.message,
  });

  @override
  List<Object?> get props => [appointment, message];
}

class AppointmentDetailsRescheduleError extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsRescheduleError({
    required super.appointment,
    required this.message,
  });

  @override
  List<Object?> get props => [appointment, message];
}
