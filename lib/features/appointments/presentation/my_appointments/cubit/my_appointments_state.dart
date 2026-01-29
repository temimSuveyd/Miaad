part of 'my_appointments_cubit.dart';

/// حالة مواعيد المستخدم
/// My Appointments State
class MyAppointmentsState extends Equatable {
  final List<MyAppointmentModel> appointments;
  final List<MyAppointmentModel> filteredAppointments;
  final AppointmentFilter selectedFilter;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const MyAppointmentsState({
    this.appointments = const [],
    this.filteredAppointments = const [],
    this.selectedFilter = AppointmentFilter.all,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  @override
  List<Object?> get props => [
    appointments,
    filteredAppointments,
    selectedFilter,
    isLoading,
    errorMessage,
    successMessage,
  ];

  /// نسخ مع تعديل
  MyAppointmentsState copyWith({
    List<MyAppointmentModel>? appointments,
    List<MyAppointmentModel>? filteredAppointments,
    AppointmentFilter? selectedFilter,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return MyAppointmentsState(
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  /// التحقق من وجود مواعيد
  bool get hasAppointments => appointments.isNotEmpty;

  /// التحقق من وجود مواعيد مفلترة
  bool get hasFilteredAppointments => filteredAppointments.isNotEmpty;

  /// التحقق من وجود خطأ
  bool get hasError => errorMessage != null;

  /// التحقق من وجود رسالة نجاح
  bool get hasSuccessMessage => successMessage != null;

  /// الحصول على عدد المواعيد المفلترة
  int get filteredAppointmentsCount => filteredAppointments.length;

  /// الحصول على عدد المواعيد الإجمالي
  int get totalAppointmentsCount => appointments.length;

  @override
  String toString() {
    return 'MyAppointmentsState(appointments: ${appointments.length}, filteredAppointments: ${filteredAppointments.length}, selectedFilter: $selectedFilter, isLoading: $isLoading)';
  }
}

/// فلاتر المواعيد
enum AppointmentFilter { all, upcoming, completed, cancelled }

/// امتداد لفلاتر المواعيد
extension AppointmentFilterExtension on AppointmentFilter {
  String get displayName {
    switch (this) {
      case AppointmentFilter.all:
        return 'الكل';
      case AppointmentFilter.upcoming:
        return 'القادمة';
      case AppointmentFilter.completed:
        return 'المكتملة';
      case AppointmentFilter.cancelled:
        return 'الملغية';
    }
  }

  String get description {
    switch (this) {
      case AppointmentFilter.all:
        return 'جميع المواعيد';
      case AppointmentFilter.upcoming:
        return 'المواعيد القادمة والمعاد جدولتها';
      case AppointmentFilter.completed:
        return 'المواعيد المكتملة';
      case AppointmentFilter.cancelled:
        return 'المواعيد الملغية';
    }
  }
}
