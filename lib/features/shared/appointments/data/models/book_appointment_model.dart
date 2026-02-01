import 'package:equatable/equatable.dart';
import 'work_hours.dart';
import 'slot_model.dart';

/// نموذج حجز الموعد - مخصص لعملية حجز المواعيد (البيانات الأساسية)
/// Book Appointment Model - Specific for appointment booking process (Basic data)
class BookAppointmentModel extends Equatable {
  final String? doctorId;
  final String? doctorName;
  final String? hospitalName;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<String> availableTimes;
  final Map<DateTime, List<String>> availableSlots;
  final WorkHours? workHours;
  final BookingStep currentStep;
  final bool isLoading;
  final String? errorMessage;
  // معلومات السلوتس الجديدة
  final List<SlotModel> availableSlotModels;
  final SlotModel? selectedSlot;

  const BookAppointmentModel({
    required this.doctorId,
     this.doctorName,
     this.hospitalName,
    this.selectedDate,
    this.selectedTime,
    required this.availableTimes,
    required this.availableSlots,
    this.workHours,
    required this.currentStep,
    required this.isLoading,
    this.errorMessage,
    this.availableSlotModels = const [],
    this.selectedSlot,
  });

  @override
  List<Object?> get props => [
    doctorId,
    doctorName,
    hospitalName,
    selectedDate,
    selectedTime,
    availableTimes,
    availableSlots,
    workHours,
    currentStep,
    isLoading,
    errorMessage,
    availableSlotModels,
    selectedSlot,
  ];

  /// إنشاء حالة أولية
  factory BookAppointmentModel.initial({
    required String doctorId,
  }) {
    return BookAppointmentModel(
      doctorId: doctorId,
      availableTimes: [],
      availableSlots: {},
      currentStep: BookingStep.selectDate,
      isLoading: false,
    );
  }

  /// نسخ مع تعديل
  BookAppointmentModel copyWith({
    String? doctorId,
    String? doctorName,
    String? hospitalName,
    DateTime? selectedDate,
    String? selectedTime,
    List<String>? availableTimes,
    Map<DateTime, List<String>>? availableSlots,
    WorkHours? workHours,
    BookingStep? currentStep,
    bool? isLoading,
    String? errorMessage,
    List<SlotModel>? availableSlotModels,
    SlotModel? selectedSlot,
  }) {
    return BookAppointmentModel(
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      availableTimes: availableTimes ?? this.availableTimes,
      availableSlots: availableSlots ?? this.availableSlots,
      workHours: workHours ?? this.workHours,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableSlotModels: availableSlotModels ?? this.availableSlotModels,
      selectedSlot: selectedSlot ?? this.selectedSlot,
    );
  }

  /// مسح رسالة الخطأ
  BookAppointmentModel clearError() {
    return copyWith(errorMessage: null);
  }

  /// تعيين حالة التحميل
  BookAppointmentModel setLoading(bool loading) {
    return copyWith(isLoading: loading, errorMessage: null);
  }

  /// تعيين خطأ
  BookAppointmentModel setError(String error) {
    return copyWith(errorMessage: error, isLoading: false);
  }

  /// التحقق من إمكانية المتابعة للخطوة التالية
  bool get canProceedToNextStep {
    switch (currentStep) {
      case BookingStep.selectDate:
        return selectedDate != null;
      case BookingStep.selectTime:
        return selectedTime != null;
      case BookingStep.confirm:
        return selectedDate != null && selectedTime != null;
    }
  }

  /// التحقق من إمكانية العودة للخطوة السابقة
  bool get canGoToPreviousStep {
    return currentStep != BookingStep.selectDate;
  }

  /// الحصول على الخطوة التالية
  BookingStep? get nextStep {
    switch (currentStep) {
      case BookingStep.selectDate:
        return BookingStep.selectTime;
      case BookingStep.selectTime:
        return BookingStep.confirm;
      case BookingStep.confirm:
        return null; // آخر خطوة
    }
  }

  /// الحصول على الخطوة السابقة
  BookingStep? get previousStep {
    switch (currentStep) {
      case BookingStep.selectDate:
        return null; // أول خطوة
      case BookingStep.selectTime:
        return BookingStep.selectDate;
      case BookingStep.confirm:
        return BookingStep.selectTime;
    }
  }

  /// الحصول على الأوقات المتاحة للتاريخ المحدد
  List<String> getAvailableTimesForDate(DateTime date) {
    // إذا كانت ساعات العمل متوفرة، استخدمها
    if (workHours != null) {
      return workHours!.getTimeSlotsForDate(date);
    }
    // وإلا استخدم الطريقة القديمة
    return availableSlots[date] ?? [];
  }

  /// التحقق من توفر وقت معين في تاريخ معين
  bool isTimeAvailable(DateTime date, String time) {
    // إذا كانت ساعات العمل متوفرة، استخدمها
    if (workHours != null) {
      return workHours!.isTimeAvailable(WorkHours.getDayKey(date), time);
    }
    // وإلا استخدم الطريقة القديمة
    return availableSlots[date]?.contains(time) ?? false;
  }

  /// التحقق من كون التاريخ يوم عمل
  bool isWorkingDay(DateTime date) {
    if (workHours != null) {
      return workHours!.isWorkingDay(date);
    }
    // الطريقة القديمة - تجنب عطلة نهاية الأسبوع
    return date.weekday != DateTime.friday && date.weekday != DateTime.saturday;
  }

  /// الحصول على عدد الأيام المتاحة
  int get availableDaysCount => availableSlots.keys.length;

  /// الحصول على إجمالي الأوقات المتاحة
  int get totalAvailableSlots {
    return availableSlots.values.fold(0, (sum, times) => sum + times.length);
  }

  @override
  String toString() {
    return 'BookAppointmentModel(doctorId: $doctorId, selectedDate: $selectedDate, selectedTime: $selectedTime, currentStep: $currentStep, isLoading: $isLoading, hasSlot: ${selectedSlot != null})';
  }
}

/// خطوات حجز الموعد (مبسطة)
enum BookingStep { selectDate, selectTime, confirm }

/// امتداد لخطوات الحجز
extension BookingStepExtension on BookingStep {
  String get displayName {
    switch (this) {
      case BookingStep.selectDate:
        return 'اختيار التاريخ';
      case BookingStep.selectTime:
        return 'اختيار الوقت';
      case BookingStep.confirm:
        return 'تأكيد الحجز';
    }
  }

  String get description {
    switch (this) {
      case BookingStep.selectDate:
        return 'اختر التاريخ المناسب لموعدك';
      case BookingStep.selectTime:
        return 'اختر الوقت المناسب من الأوقات المتاحة';
      case BookingStep.confirm:
        return 'راجع تفاصيل موعدك وأكد الحجز';
    }
  }

  int get stepNumber {
    switch (this) {
      case BookingStep.selectDate:
        return 1;
      case BookingStep.selectTime:
        return 2;
      case BookingStep.confirm:
        return 3;
    }
  }

  double get progress {
    return stepNumber / 3.0;
  }
}
