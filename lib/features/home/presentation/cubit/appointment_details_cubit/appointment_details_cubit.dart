import 'package:doctorbooking/features/appointments/data/repositories/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../appointments/data/models/appointment.dart';
import 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final SharedAppointmentRepository repository;
  final AppointmentModel appointment;

  AppointmentDetailsCubit({required this.repository, required this.appointment})
    : super(AppointmentDetailsInitial(appointment: appointment));

  // Cancel appointment
  Future<void> cancelAppointment() async {
    emit(AppointmentDetailsCancelling(appointment: appointment));

    final result = await repository.cancelAppointment(
      appointment.id!,
      appointment.userId,
    );

    result.fold(
      (failure) {
        emit(
          AppointmentDetailsCancelError(
            appointment: appointment,
            message: failure.message,
          ),
        );
      },
      (cancelledAppointment) {
        emit(
          AppointmentDetailsCancelled(
            appointment: cancelledAppointment,
            message: 'تم إلغاء الموعد بنجاح',
          ),
        );
      },
    );
  }

  // Reschedule appointment
  Future<void> rescheduleAppointment(DateTime newDate, String newTime) async {
    emit(AppointmentDetailsRescheduling(appointment: appointment));

    final result = await repository.rescheduleAppointment(
      appointment.id!,
      newDate,
      newTime,
      appointment.userId,
    );

    result.fold(
      (failure) {
        emit(
          AppointmentDetailsRescheduleError(
            appointment: appointment,
            message: failure.message,
          ),
        );
      },
      (rescheduledAppointment) {
        emit(
          AppointmentDetailsRescheduled(
            appointment: rescheduledAppointment,
            message: 'تم إعادة جدولة الموعد بنجاح',
          ),
        );
      },
    );
  }
}
