import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/models/appointment_details_model.dart';
import '../../../data/models/appointment.dart';

part 'appointment_details_state.dart';

/// Cubit لإدارة تفاصيل الموعد
/// Appointment Details Cubit - Manages appointment details
class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final SharedAppointmentRepository repository;

  AppointmentDetailsCubit({required this.repository})
    : super(const AppointmentDetailsState());

  /// تحميل تفاصيل الموعد
  Future<void> loadAppointmentDetails(String appointmentId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.getAppointmentById(appointmentId);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointment) {
        final appointmentDetails = AppointmentDetailsModel.fromAppointment(
          appointment,
        );
        emit(
          state.copyWith(
            isLoading: false,
            appointmentDetails: appointmentDetails,
          ),
        );
      },
    );
  }

  /// إلغاء الموعد
  Future<void> cancelAppointment(
    String appointmentId,
    String cancelledBy,
  ) async {
    if (state.appointmentDetails == null) return;

    emit(state.copyWith(isActionLoading: true, errorMessage: null));

    final result = await repository.cancelAppointment(
      appointmentId,
      cancelledBy,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isActionLoading: false, errorMessage: failure.message),
      ),
      (updatedAppointment) {
        final updatedDetails = AppointmentDetailsModel.fromAppointment(
          updatedAppointment,
        );
        emit(
          state.copyWith(
            isActionLoading: false,
            appointmentDetails: updatedDetails,
            successMessage: 'تم إلغاء الموعد بنجاح',
          ),
        );
      },
    );
  }

  /// إعادة جدولة الموعد
  Future<void> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  ) async {
    if (state.appointmentDetails == null) return;

    emit(state.copyWith(isActionLoading: true, errorMessage: null));

    final result = await repository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
      rescheduledBy,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isActionLoading: false, errorMessage: failure.message),
      ),
      (updatedAppointment) {
        final updatedDetails = AppointmentDetailsModel.fromAppointment(
          updatedAppointment,
        );
        emit(
          state.copyWith(
            isActionLoading: false,
            appointmentDetails: updatedDetails,
            successMessage: 'تم إعادة جدولة الموعد بنجاح',
          ),
        );
      },
    );
  }

  /// تحديث تفاصيل الموعد
  Future<void> refreshAppointmentDetails(String appointmentId) async {
    await loadAppointmentDetails(appointmentId);
  }

  /// تنفيذ إجراء معين
  Future<void> executeAction(
    AppointmentAction action,
    String appointmentId,
    String userId,
  ) async {
    switch (action) {
      case AppointmentAction.cancel:
        await cancelAppointment(appointmentId, userId);
        break;
      case AppointmentAction.reschedule:
        // سيتم التعامل معه في الواجهة
        break;
      case AppointmentAction.viewReceipt:
        emit(state.copyWith(successMessage: 'سيتم عرض الإيصال قريباً'));
        break;
      case AppointmentAction.rateDoctor:
        emit(state.copyWith(successMessage: 'سيتم فتح صفحة التقييم قريباً'));
        break;
      case AppointmentAction.contactDoctor:
        emit(state.copyWith(successMessage: 'سيتم فتح صفحة التواصل قريباً'));
        break;
      case AppointmentAction.getDirections:
        emit(state.copyWith(successMessage: 'سيتم فتح الخريطة قريباً'));
        break;
    }
  }

  /// مسح الرسائل
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  /// تعيين حالة عرض التاريخ
  void toggleHistoryVisibility() {
    emit(state.copyWith(showHistory: !state.showHistory));
  }

  /// تعيين الإجراء المحدد
  void setSelectedAction(AppointmentAction? action) {
    emit(state.copyWith(selectedAction: action));
  }
}
