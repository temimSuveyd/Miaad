import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/models/book_appointment_model.dart';
import '../../../data/models/book_appointment_request.dart';
import '../../../data/models/appointment.dart';
import '../../../data/models/work_hours.dart';

part 'book_appointment_state.dart';

/// Cubit لإدارة حجز المواعيد
/// Book Appointment Cubit - Manages appointment booking
class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final SharedAppointmentRepository repository;

  BookAppointmentCubit({required this.repository})
    : super(const BookAppointmentState());

  /// بدء عملية حجز موعد جديد
  void startBooking({
    required String doctorId,
    required String doctorName,
    required String hospitalName,
  }) {
    final bookingModel = BookAppointmentModel.initial(
      doctorId: doctorId,
      doctorName: doctorName,
      hospitalName: hospitalName,
    );

    emit(state.copyWith(bookingModel: bookingModel));

    // تحميل الأوقات المتاحة
    _loadAvailableSlots(doctorId);
  }

  /// تحميل الأوقات المتاحة للطبيب
  Future<void> _loadAvailableSlots(String doctorId) async {
    if (state.bookingModel == null) return;

    emit(state.copyWith(bookingModel: state.bookingModel!.setLoading(true)));

    try {
      // تحميل ساعات العمل من الخادم
      final workHours = await _loadWorkHours(doctorId);

      // إنشاء الأوقات المتاحة بناءً على ساعات العمل
      final availableSlots = _generateAvailableSlotsFromWorkHours(workHours);

      emit(
        state.copyWith(
          bookingModel: state.bookingModel!.copyWith(
            workHours: workHours,
            availableSlots: availableSlots,
            isLoading: false,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bookingModel: state.bookingModel!.setError(
            'فشل في تحميل الأوقات المتاحة',
          ),
        ),
      );
    }
  }

  /// تحميل ساعات العمل من الخادم
  Future<WorkHours> _loadWorkHours(String doctorId) async {
    // محاكاة استدعاء API لتحميل ساعات العمل
    await Future.delayed(const Duration(seconds: 1));

    // البيانات الجديدة من الخادم - فقط الأيام والأوقات المتاحة
    final workHoursJson = {
      "days": {
        "Mon": ["10:00", "11:00", "12:00", "14:00", "15:00"],
        "Tue": ["09:00", "10:00", "11:00", "13:00", "14:00"],
        "Wed": ["10:00", "11:00", "12:00", "15:00", "16:00"],
        "Thu": ["08:00", "09:00", "10:00", "14:00", "15:00"],
        "Fri": ["10:00", "11:00", "12:00", "13:00", "16:00"],
      },
    };

    return WorkHours.fromJson(workHoursJson);
  }

  /// إنشاء الأوقات المتاحة بناءً على ساعات العمل (أسبوع حالي فقط)
  Map<DateTime, List<String>> _generateAvailableSlotsFromWorkHours(
    WorkHours workHours,
  ) {
    final Map<DateTime, List<String>> slots = {};
    final now = DateTime.now();
    
    // الحصول على بداية الأسبوع الحالي (السبت)
    final startOfWeek = now.subtract(Duration(days: (now.weekday + 1) % 7));
    
    // إنشاء أوقات متاحة للأسبوع الحالي فقط (7 أيام)
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      
      // تجاهل الأيام الماضية
      if (date.isBefore(DateTime(now.year, now.month, now.day))) {
        continue;
      }
      
      // التحقق من كون اليوم موجود في ساعات العمل
      final dayKey = WorkHours.getDayKey(date);
      if (workHours.days.containsKey(dayKey)) {
        final timeSlots = workHours.getTimeSlotsForDate(date);
        if (timeSlots.isNotEmpty) {
          slots[date] = timeSlots;
        }
      }
    }

    return slots;
  }



  /// اختيار تاريخ
  void selectDate(DateTime date) {
    if (state.bookingModel == null) {
      return;
    }

    final availableTimes = state.bookingModel!.getAvailableTimesForDate(date);

    emit(
      state.copyWith(
        bookingModel: state.bookingModel!.copyWith(
          selectedDate: date,
          availableTimes: availableTimes,
          selectedTime: null, // مسح الوقت المحدد عند تغيير التاريخ
        ),
      ),
    );
  }

  /// اختيار وقت
  void selectTime(String time) {
    if (state.bookingModel == null) {
      return;
    }

    emit(
      state.copyWith(
        bookingModel: state.bookingModel!.copyWith(selectedTime: time),
      ),
    );
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

  /// تأكيد الحجز
  Future<void> confirmBooking(String userId) async {
    if (state.bookingModel == null ||
        state.bookingModel!.selectedDate == null ||
        state.bookingModel!.selectedTime == null) {
      return;
    }

    emit(state.copyWith(bookingModel: state.bookingModel!.setLoading(true)));

    final request = BookAppointmentRequest(
      userId: userId,
      doctorId: state.bookingModel!.doctorId,
      date: state.bookingModel!.selectedDate!,
      time: state.bookingModel!.selectedTime!,
    );

    // تحويل الطلب إلى AppointmentModel
    final appointment = AppointmentModel(
      userId: request.userId,
      doctorId: request.doctorId,
      date: request.date,
      time: request.time,
      status: AppointmentStatus.upcoming,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      doctorName: state.bookingModel!.doctorName,
      hospitalName: state.bookingModel!.hospitalName,
    );

    final result = await repository.createAppointment(appointment);

    result.fold(
      (failure) => emit(
        state.copyWith(
          bookingModel: state.bookingModel!.setError(failure.message),
        ),
      ),
      (createdAppointment) => emit(
        state.copyWith(
          bookingModel: state.bookingModel!.setLoading(false),
          isBookingComplete: true,
          bookedAppointment: createdAppointment,
          successMessage: 'تم حجز الموعد بنجاح',
        ),
      ),
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
