import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/models/appointment_details_model.dart';
import '../../../data/models/appointment.dart';
import '../../../data/models/slot_model.dart';

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
            successMessage: 'تم إلغاء الموعد وتحرير السلوت بنجاح',
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
            successMessage: 'تم إعادة جدولة الموعد بنجاح مع تغيير السلوت',
          ),
        );
      },
    );
  }

  /// تحديث تفاصيل الموعد
  Future<void> refreshAppointmentDetails(String appointmentId) async {
    await loadAppointmentDetails(appointmentId);
  }

  // ========== Slot System Methods ==========

  /// الحصول على معلومات السلوت للموعد
  Future<void> loadSlotForAppointment(String appointmentId) async {
    if (state.appointmentDetails?.appointment?.slotId != null) {
      final slotId = state.appointmentDetails!.appointment!.slotId!;
      
      final result = await repository.getSlotById(slotId);
      
      result.fold(
        (failure) => emit(
          state.copyWith(errorMessage: 'فشل في تحميل معلومات السلوت: ${failure.message}'),
        ),
        (slot) {
          // تحديث معلومات الموعد مع السلوت
          final currentAppointment = state.appointmentDetails!.appointment!;
          final updatedAppointment = currentAppointment.copyWith(slot: slot);
          final updatedDetails = AppointmentDetailsModel.fromAppointment(updatedAppointment);
          
          emit(state.copyWith(appointmentDetails: updatedDetails));
        },
      );
    }
  }

  /// الحصول على السلوتس المتاحة لإعادة الجدولة
  Future<void> loadAvailableSlotsForReschedule(String doctorId) async {
    emit(state.copyWith(isActionLoading: true, errorMessage: null));

    final result = await repository.getAvailableSlots(doctorId, daysAhead: 30);
    
    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionLoading: false, 
          errorMessage: 'فشل في تحميل السلوتس المتاحة: ${failure.message}'
        ),
      ),
      (slots) {
        emit(
          state.copyWith(
            isActionLoading: false,
            successMessage: 'تم تحميل ${slots.length} سلوت متاح لإعادة الجدولة',
          ),
        );
      },
    );
  }

  /// التحقق من إمكانية إعادة الجدولة
  bool get canReschedule {
    final appointment = state.appointmentDetails?.appointment;
    return appointment?.canBeRescheduled ?? false;
  }

  /// الحصول على معلومات السلوت الحالي
  SlotModel? get currentSlot {
    return state.appointmentDetails?.appointment?.slot;
  }

  /// الحصول على مدة السلوت الحالي
  int? get currentSlotDuration {
    return state.appointmentDetails?.appointment?.slotDuration;
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
