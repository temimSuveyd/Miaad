part of 'appointment_details_cubit.dart';

/// حالة تفاصيل الموعد
/// Appointment Details State
class AppointmentDetailsState extends Equatable {
  final AppointmentDetailsModel? appointmentDetails;
  final bool isLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool showHistory;
  final AppointmentAction? selectedAction;

  const AppointmentDetailsState({
    this.appointmentDetails,
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.successMessage,
    this.showHistory = false,
    this.selectedAction,
  });

  @override
  List<Object?> get props => [
    appointmentDetails,
    isLoading,
    isActionLoading,
    errorMessage,
    successMessage,
    showHistory,
    selectedAction,
  ];

  /// نسخ مع تعديل
  AppointmentDetailsState copyWith({
    AppointmentDetailsModel? appointmentDetails,
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    String? successMessage,
    bool? showHistory,
    AppointmentAction? selectedAction,
  }) {
    return AppointmentDetailsState(
      appointmentDetails: appointmentDetails ?? this.appointmentDetails,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      showHistory: showHistory ?? this.showHistory,
      selectedAction: selectedAction,
    );
  }

  /// التحقق من وجود تفاصيل الموعد
  bool get hasAppointmentDetails => appointmentDetails != null;

  /// التحقق من وجود خطأ
  bool get hasError => errorMessage != null;

  /// التحقق من وجود رسالة نجاح
  bool get hasSuccessMessage => successMessage != null;

  /// التحقق من إمكانية تنفيذ الإجراءات
  bool get canPerformActions => hasAppointmentDetails && !isActionLoading;

  /// الحصول على الموعد
  AppointmentModel? get appointment => appointmentDetails?.appointment;

  /// الحصول على الإجراءات المتاحة
  List<AppointmentAction> get availableActions =>
      appointmentDetails?.availableActions ?? [];

  /// التحقق من وجود إجراءات متاحة
  bool get hasAvailableActions => availableActions.isNotEmpty;

  /// التحقق من وجود معلومات إضافية
  bool get hasAdditionalInfo =>
      appointmentDetails?.additionalInfo.isNotEmpty ?? false;

  /// التحقق من وجود تاريخ
  bool get hasHistory => appointmentDetails?.history.isNotEmpty ?? false;

  /// الحصول على عدد عناصر التاريخ
  int get historyItemsCount => appointmentDetails?.history.length ?? 0;

  @override
  String toString() {
    return 'AppointmentDetailsState(hasDetails: $hasAppointmentDetails, isLoading: $isLoading, isActionLoading: $isActionLoading, showHistory: $showHistory)';
  }
}
