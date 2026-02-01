import 'dart:developer';
import 'package:doctorbooking/core/models/models.dart';
import 'package:doctorbooking/features/profile/data/mock/mock_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/models/book_appointment_model.dart';
import '../../../data/models/appointment.dart';
import '../../../data/models/slot_model.dart';

part 'book_appointment_state.dart';

/// Cubit لإدارة حجز المواعيد
/// Book Appointment Cubit - Manages appointment booking
class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final SharedAppointmentRepository repository;

  BookAppointmentCubit({required this.repository})
    : super(const BookAppointmentState());

  /// بدء عملية حجز موعد جديد
  void startBooking() {
    log("🚀 BookAppointmentCubit: startBooking() called");
    
    // Show loading state immediately
    emit(state.copyWith(bookingModel: BookAppointmentModel.initial(doctorId: '').setLoading(true)));
    log("📱 BookAppointmentCubit: Initial loading state emitted");
    
    final DoctorModel doctorModel = Get.arguments['doctor_model'];
    log("👨‍⚕️ BookAppointmentCubit: Doctor model loaded - ID: ${doctorModel.id}, Name: ${doctorModel.name}");
    
    final bookingModel = BookAppointmentModel.initial(doctorId: doctorModel.id).setLoading(true);
    emit(state.copyWith(bookingModel: bookingModel));
    log("📋 BookAppointmentCubit: Booking model created and emitted with doctor ID: ${doctorModel.id}");
    
    // تحميل السلوتس المتاحة من النظام الجديد
    _loadAvailableSlots(doctorModel.id);
  }

  /// تحميل السلوتس المتاحة للطبيب (نظام السلوتس الجديد)
  Future<void> _loadAvailableSlots(String doctorId) async {
    log("🔄 BookAppointmentCubit: _loadAvailableSlots() called for doctor: $doctorId");
    
    if (state.bookingModel == null) {
      log("❌ BookAppointmentCubit: No booking model found, returning");
      return;
    }

    emit(state.copyWith(bookingModel: state.bookingModel!.setLoading(true)));
    log("⏳ BookAppointmentCubit: Loading state set to true");

    try {
      log("📡 BookAppointmentCubit: Calling repository.getAvailableSlots() for doctor: $doctorId");
      // استخدام نظام السلوتس الجديد
      final result = await repository.getAvailableSlots(
        doctorId,
        daysAhead: 15,
      );

      log("📊 BookAppointmentCubit: Repository response received");

      result.fold(
        (failure) {
          log("❌ BookAppointmentCubit: Repository failure - ${failure.message}");
          
          // التحقق من نوع الخطأ
          if (failure.message.contains('no working hours') || 
              failure.message.contains('ساعات العمل')) {
            log("🕒 BookAppointmentCubit: No working hours error detected");
            emit(
              state.copyWith(
                bookingModel: state.bookingModel!.setLoading(false),
                hasNoWorkingHours: true,
                slotsErrorMessage: 'الطبيب لم يحدد ساعات العمل بعد',
              ),
            );
          } else {
            log("⚠️ BookAppointmentCubit: General error - ${failure.message}");
            emit(
              state.copyWith(
                bookingModel: state.bookingModel!.setError(
                  'فشل في تحميل السلوتس المتاحة: ${failure.message}',
                ),
                slotsErrorMessage: failure.message,
              ),
            );
          }
        },
        (slots) {
          log("✅ BookAppointmentCubit: Successfully loaded ${slots.length} slots");
          log("📋 BookAppointmentCubit: Slots data: ${slots.map((s) => '${s.slotDate} ${s.slotTime} (${s.status})').toList()}");
          
          if (slots.isEmpty) {
            log("📭 BookAppointmentCubit: No slots available");
            emit(
              state.copyWith(
                bookingModel: state.bookingModel!.setLoading(false),
                hasNoSlotsAvailable: true,
                slotsErrorMessage: 'لا توجد أوقات متاحة للحجز حالياً',
              ),
            );
          } else {
            log("🔄 BookAppointmentCubit: Converting slots to old format");
            // تحويل السلوتس إلى التنسيق القديم للتوافق مع الواجهة الحالية
            final availableSlots = _convertSlotsToOldFormat(slots);
            log("📅 BookAppointmentCubit: Converted slots: ${availableSlots.keys.toList()}");

            emit(
              state.copyWith(
                bookingModel: state.bookingModel!.copyWith(
                  availableSlots: availableSlots,
                  availableSlotModels: slots, // حفظ السلوتس الأصلية
                  isLoading: false,
                ),
                hasNoSlotsAvailable: false,
                hasNoWorkingHours: false,
                slotsErrorMessage: null,
              ),
            );
            log("✅ BookAppointmentCubit: State updated with slots data");
          }
        },
      );
    } catch (e) {
      log("💥 BookAppointmentCubit: Exception in _loadAvailableSlots - $e");
      emit(
        state.copyWith(
          bookingModel: state.bookingModel!.setError(
            'فشل في تحميل السلوتس المتاحة: $e',
          ),
          slotsErrorMessage: e.toString(),
        ),
      );
    }
  }

  /// تحويل السلوتس الجديدة إلى التنسيق القديم للتوافق مع الواجهة الحالية
  Map<DateTime, List<String>> _convertSlotsToOldFormat(List<SlotModel> slots) {
    final Map<DateTime, List<String>> formattedSlots = {};

    for (final slot in slots) {
      if (slot.isAvailable && !slot.isPast) {
        final date = slot.slotDate;
        final time = slot.slotTime;

        if (!formattedSlots.containsKey(date)) {
          formattedSlots[date] = [];
        }
        formattedSlots[date]!.add(time);
      }
    }

    // ترتيب الأوقات لكل تاريخ
    for (final date in formattedSlots.keys) {
      formattedSlots[date]!.sort();
    }

    return formattedSlots;
  }

  /// اختيار تاريخ
  void selectDate(DateTime date) {
    log("📅 BookAppointmentCubit: selectDate() called with date: $date");
    
    if (state.bookingModel == null) {
      log("❌ BookAppointmentCubit: No booking model found in selectDate");
      return;
    }

    final availableTimes = state.bookingModel!.getAvailableTimesForDate(date);
    log("⏰ BookAppointmentCubit: Available times for $date: $availableTimes");

    emit(
      state.copyWith(
        bookingModel: state.bookingModel!.copyWith(
          selectedDate: date,
          availableTimes: availableTimes,
          selectedTime: null, // مسح الوقت المحدد عند تغيير التاريخ
        ),
      ),
    );
    log("✅ BookAppointmentCubit: Date selected and state updated");
  }

  /// اختيار وقت (مع تحديد السلوت المقابل)
  void selectTime(String time) {
    log("⏰ BookAppointmentCubit: selectTime() called with time: $time");
    
    if (state.bookingModel == null ||
        state.bookingModel!.selectedDate == null) {
      log("❌ BookAppointmentCubit: No booking model or selected date found in selectTime");
      return;
    }

    final selectedDate = state.bookingModel!.selectedDate!;
    log("🔍 BookAppointmentCubit: Looking for slot on $selectedDate at $time");

    // البحث عن السلوت المقابل للتاريخ والوقت المحددين
    final selectedSlot = _findSlotByDateTime(selectedDate, time);
    log("🎯 BookAppointmentCubit: Found slot: ${selectedSlot?.id ?? 'null'}");

    emit(
      state.copyWith(
        bookingModel: state.bookingModel!.copyWith(
          selectedTime: time,
          selectedSlot: selectedSlot,
        ),
      ),
    );
    log("✅ BookAppointmentCubit: Time selected and state updated");
  }

  /// البحث عن سلوت بالتاريخ والوقت
  SlotModel? _findSlotByDateTime(DateTime date, String time) {
    final slots = state.bookingModel?.availableSlotModels ?? [];

    try {
      return slots.firstWhere(
        (slot) =>
            slot.slotDate.year == date.year &&
            slot.slotDate.month == date.month &&
            slot.slotDate.day == date.day &&
            slot.slotTime == time &&
            slot.isAvailable,
      );
    } catch (e) {
      return null;
    }
  }

  /// الانتقال للخطوة التالية
  void goToNextStep() {
    if (state.bookingModel == null ||
        !state.bookingModel!.canProceedToNextStep) {
      return;
    }

    final nextStep = state.bookingModel!.nextStep;
    if (nextStep != null) {
      emit(
        state.copyWith(
          bookingModel: state.bookingModel!.copyWith(currentStep: nextStep),
        ),
      );
    }
  }

  /// العودة للخطوة السابقة
  void goToPreviousStep() {
    if (state.bookingModel == null ||
        !state.bookingModel!.canGoToPreviousStep) {
      return;
    }

    final previousStep = state.bookingModel!.previousStep;
    if (previousStep != null) {
      emit(
        state.copyWith(
          bookingModel: state.bookingModel!.copyWith(currentStep: previousStep),
        ),
      );
    }
  }

  /// الانتقال لخطوة معينة
  void goToStep(BookingStep step) {
    if (state.bookingModel == null) {
      return;
    }

    emit(
      state.copyWith(
        bookingModel: state.bookingModel!.copyWith(currentStep: step),
      ),
    );
  }

  /// تأكيد الحجز (باستخدام نظام السلوتس)
  Future<void> confirmBooking(String userId) async {
    
    if (state.bookingModel == null ||
        state.bookingModel!.selectedDate == null ||
        state.bookingModel!.selectedTime == null ||
        state.bookingModel!.selectedSlot == null) {      
      emit(
        state.copyWith(
          bookingModel: state.bookingModel?.setError(
            'يرجى اختيار التاريخ والوقت المناسبين',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(bookingModel: state.bookingModel!.setLoading(true)));

    final selectedSlot = state.bookingModel!.selectedSlot!;
    
    // إنشاء الموعد مع معلومات السلوت
    final appointment = AppointmentModel(
      userId: userId,
      doctorId: state.bookingModel!.doctorId!,
      date: state.bookingModel!.selectedDate!,
      time: state.bookingModel!.selectedTime!,
      status: AppointmentStatus.upcoming,
      notes: '',
      hospitalName: state.bookingModel!.hospitalName,
      slotId: selectedSlot.id,
      slot: selectedSlot,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    // استخدام طريقة الحجز بالسلوت
    final result = await repository.createAppointmentWithSlot(
      appointment,
      selectedSlot.id!,
    );

    result.fold(
      (failure) {
        log("❌ BookAppointmentCubit: Booking failed - ${failure.message}");
        emit(
          state.copyWith(
            bookingModel: state.bookingModel!.setError(
              'فشل في حجز الموعد: ${failure.message}',
            ),
          ),
        );
      },
      (createdAppointment) {
        log("✅ BookAppointmentCubit: Booking successful - Appointment ID: ${createdAppointment.id}");
        emit(
          state.copyWith(
            bookingModel: state.bookingModel!.setLoading(false),
            isBookingComplete: true,
            bookedAppointment: createdAppointment,
            successMessage: 'تم حجز الموعد بنجاح باستخدام السلوت',
          ),
        );
        log("🎉 BookAppointmentCubit: Booking complete state emitted");
      },
    );
  }

  /// إعادة تعيين عملية الحجز
  void resetBooking() {
    emit(const BookAppointmentState());
  }

  /// مسح الرسائل
  void clearMessages() {
    emit(
      state.copyWith(
        bookingModel: state.bookingModel?.clearError(),
        successMessage: null,
      ),
    );
  }

  /// التحقق من توفر وقت معين
  bool isTimeSlotAvailable(DateTime date, String time) {
    return state.bookingModel?.isTimeAvailable(date, time) ?? false;
  }

  /// الحصول على الأوقات المتاحة لتاريخ معين
  List<String> getAvailableTimesForDate(DateTime date) {
    return state.bookingModel?.getAvailableTimesForDate(date) ?? [];
  }

  /// التحقق من كون التاريخ يوم عمل
  bool isWorkingDay(DateTime date) {
    return state.bookingModel?.isWorkingDay(date) ?? false;
  }
}
