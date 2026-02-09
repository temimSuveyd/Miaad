part of 'reschedule_appointment_cubit.dart';

// import 'package:equatable/equatable.dart';

/// حالة إعادة جدولة الموعد
/// Reschedule Appointment State
class RescheduleAppointmentState extends Equatable {
  final bool isLoading;
  final bool isRescheduled;
  final String? error;
  final String? successMessage;

  const RescheduleAppointmentState({
    this.isLoading = false,
    this.isRescheduled = false,
    this.error,
    this.successMessage,
  });

  /// نسخ الكائن مع تعديل بعض الخصائص
  /// Copy object with modified properties
  RescheduleAppointmentState copyWith({
    bool? isLoading,
    bool? isRescheduled,
    String? error,
    String? successMessage,
  }) {
    return RescheduleAppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isRescheduled: isRescheduled ?? this.isRescheduled,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRescheduled,
        error,
        successMessage,
      ];

  @override
  String toString() {
    return 'RescheduleAppointmentState(isLoading: $isLoading, isRescheduled: $isRescheduled, error: $error, successMessage: $successMessage)';
  }
}
