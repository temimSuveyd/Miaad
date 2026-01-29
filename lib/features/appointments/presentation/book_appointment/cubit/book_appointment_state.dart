part of 'book_appointment_cubit.dart';

/// حالة حجز الموعد
/// Book Appointment State
class BookAppointmentState extends Equatable {
  final BookAppointmentModel? bookingModel;
  final bool isBookingComplete;
  final AppointmentModel? bookedAppointment;
  final String? successMessage;

  const BookAppointmentState({
    this.bookingModel,
    this.isBookingComplete = false,
    this.bookedAppointment,
    this.successMessage,
  });

  @override
  List<Object?> get props => [
    bookingModel,
    isBookingComplete,
    bookedAppointment,
    successMessage,
  ];

  /// نسخ مع تعديل
  BookAppointmentState copyWith({
    BookAppointmentModel? bookingModel,
    bool? isBookingComplete,
    AppointmentModel? bookedAppointment,
    String? successMessage,
  }) {
    return BookAppointmentState(
      bookingModel: bookingModel ?? this.bookingModel,
      isBookingComplete: isBookingComplete ?? this.isBookingComplete,
      bookedAppointment: bookedAppointment ?? this.bookedAppointment,
      successMessage: successMessage,
    );
  }

  /// التحقق من بدء عملية الحجز
  bool get isBookingStarted => bookingModel != null;

  /// التحقق من حالة التحميل
  bool get isLoading => bookingModel?.isLoading ?? false;

  /// التحقق من وجود خطأ
  bool get hasError => bookingModel?.errorMessage != null;

  /// الحصول على رسالة الخطأ
  String? get errorMessage => bookingModel?.errorMessage;

  /// التحقق من وجود رسالة نجاح
  bool get hasSuccessMessage => successMessage != null;

  /// الحصول على الخطوة الحالية
  BookingStep? get currentStep => bookingModel?.currentStep;

  /// التحقق من إمكانية المتابعة
  bool get canProceedToNextStep => bookingModel?.canProceedToNextStep ?? false;

  /// التحقق من إمكانية العودة
  bool get canGoToPreviousStep => bookingModel?.canGoToPreviousStep ?? false;

  /// الحصول على التاريخ المحدد
  DateTime? get selectedDate => bookingModel?.selectedDate;

  /// الحصول على الوقت المحدد
  String? get selectedTime => bookingModel?.selectedTime;

  /// الحصول على الأوقات المتاحة
  List<String> get availableTimes => bookingModel?.availableTimes ?? [];

  /// الحصول على الأوقات المتاحة لجميع التواريخ
  Map<DateTime, List<String>> get availableSlots =>
      bookingModel?.availableSlots ?? {};

  /// الحصول على معلومات الطبيب
  String? get doctorName => bookingModel?.doctorName;
  String? get hospitalName => bookingModel?.hospitalName;
  String? get doctorId => bookingModel?.doctorId;

  /// التحقق من اكتمال البيانات المطلوبة
  bool get isReadyToBook =>
      selectedDate != null && selectedTime != null && !isLoading;

  /// الحصول على نسبة التقدم
  double get progress => bookingModel?.currentStep.progress ?? 0.0;

  /// التحقق من وجود أوقات متاحة
  bool get hasAvailableSlots => availableSlots.isNotEmpty;

  /// الحصول على عدد الأيام المتاحة
  int get availableDaysCount => availableSlots.keys.length;

  /// التحقق من إجمالي الأوقات المتاحة
  int get totalAvailableSlots => bookingModel?.totalAvailableSlots ?? 0;

  /// التحقق من كون اليوم عطلة
  bool get isTodayHoliday {
    final today = DateTime.now();

    // إذا كانت ساعات العمل متوفرة، استخدمها للتحقق
    if (bookingModel?.workHours != null) {
      return !bookingModel!.workHours!.isWorkingDay(today);
    }

    // الطريقة القديمة - الجمعة والسبت عطلة
    return today.weekday == DateTime.friday ||
        today.weekday == DateTime.saturday;
  }

  /// الحصول على رسالة العطلة
  String get holidayMessage {
    final today = DateTime.now();

    // إذا كانت ساعات العمل متوفرة، استخدمها
    if (bookingModel?.workHours != null) {
      if (!bookingModel!.workHours!.isWorkingDay(today)) {
        final dayNames = {
          DateTime.monday: 'الاثنين',
          DateTime.tuesday: 'الثلاثاء',
          DateTime.wednesday: 'الأربعاء',
          DateTime.thursday: 'الخميس',
          DateTime.friday: 'الجمعة',
          DateTime.saturday: 'السبت',
          DateTime.sunday: 'الأحد',
        };
        final dayName = dayNames[today.weekday] ?? '';
        return 'اليوم عطلة ($dayName) - لا يمكن حجز المواعيد';
      }
    } else {
      // الطريقة القديمة
      if (today.weekday == DateTime.friday) {
        return 'اليوم عطلة (الجمعة) - لا يمكن حجز المواعيد';
      } else if (today.weekday == DateTime.saturday) {
        return 'اليوم عطلة (السبت) - لا يمكن حجز المواعيد';
      }
    }

    return '';
  }

  @override
  String toString() {
    return 'BookAppointmentState(isBookingStarted: $isBookingStarted, currentStep: $currentStep, isLoading: $isLoading, isBookingComplete: $isBookingComplete)';
  }
}
