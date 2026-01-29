import 'package:equatable/equatable.dart';
import 'appointment.dart';

/// نموذج مواعيدي - مخصص لعرض مواعيد المستخدم
/// My Appointments Model - Specific for displaying user appointments
class MyAppointmentModel extends Equatable {
  final AppointmentModel appointment;
  final bool canCancel;
  final bool canReschedule;
  final bool canViewDetails;
  final String statusDisplayText;

  const MyAppointmentModel({
    required this.appointment,
    required this.canCancel,
    required this.canReschedule,
    required this.canViewDetails,
    required this.statusDisplayText,
  });

  @override
  List<Object?> get props => [
    appointment,
    canCancel,
    canReschedule,
    canViewDetails,
    statusDisplayText,
  ];

  /// إنشاء من AppointmentModel
  factory MyAppointmentModel.fromAppointment(AppointmentModel appointment) {
    final now = DateTime.now();
    final appointmentDateTime = DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
      int.parse(appointment.time.split(':')[0]),
      int.parse(appointment.time.split(':')[1]),
    );

    final isUpcoming = appointmentDateTime.isAfter(now);
    final canCancel =
        isUpcoming &&
        (appointment.status == AppointmentStatus.upcoming ||
            appointment.status == AppointmentStatus.rescheduled);

    final canReschedule =
        isUpcoming &&
        (appointment.status == AppointmentStatus.upcoming ||
            appointment.status == AppointmentStatus.rescheduled);

    String statusText;
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        statusText = isUpcoming ? 'موعد قادم' : 'موعد فائت';
        break;
      case AppointmentStatus.completed:
        statusText = 'مكتمل';
        break;
      case AppointmentStatus.cancelled:
        statusText = 'ملغي';
        break;
      case AppointmentStatus.rescheduled:
        statusText = 'معاد جدولته';
        break;
    }

    return MyAppointmentModel(
      appointment: appointment,
      canCancel: canCancel,
      canReschedule: canReschedule,
      canViewDetails: true,
      statusDisplayText: statusText,
    );
  }

  /// نسخ مع تعديل
  MyAppointmentModel copyWith({
    AppointmentModel? appointment,
    bool? canCancel,
    bool? canReschedule,
    bool? canViewDetails,
    String? statusDisplayText,
  }) {
    return MyAppointmentModel(
      appointment: appointment ?? this.appointment,
      canCancel: canCancel ?? this.canCancel,
      canReschedule: canReschedule ?? this.canReschedule,
      canViewDetails: canViewDetails ?? this.canViewDetails,
      statusDisplayText: statusDisplayText ?? this.statusDisplayText,
    );
  }

  /// الحصول على النص المناسب للإجراء الأساسي
  String get primaryActionText {
    if (canReschedule) return 'إعادة جدولة';
    if (canCancel) return 'إلغاء';
    return 'عرض التفاصيل';
  }

  /// الحصول على النص المناسب للإجراء الثانوي
  String? get secondaryActionText {
    if (canCancel && canReschedule) return 'إلغاء';
    return null;
  }

  /// التحقق من إمكانية تنفيذ إجراءات
  bool get hasActions => canCancel || canReschedule;

  @override
  String toString() {
    return 'MyAppointmentModel(appointment: ${appointment.id}, canCancel: $canCancel, canReschedule: $canReschedule, statusDisplayText: $statusDisplayText)';
  }
}
