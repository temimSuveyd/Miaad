import 'package:equatable/equatable.dart';
import 'appointment.dart';

/// نموذج تفاصيل الموعد - مخصص لعرض تفاصيل موعد محدد
/// Appointment Details Model - Specific for displaying appointment details
class AppointmentDetailsModel extends Equatable {
  final AppointmentModel appointment;
  final List<AppointmentAction> availableActions;
  final Map<String, String> additionalInfo;
  final bool showRescheduleHistory;
  final List<AppointmentHistoryItem> history;

  const AppointmentDetailsModel({
    required this.appointment,
    required this.availableActions,
    required this.additionalInfo,
    required this.showRescheduleHistory,
    required this.history,
  });

  @override
  List<Object?> get props => [
    appointment,
    availableActions,
    additionalInfo,
    showRescheduleHistory,
    history,
  ];

  /// إنشاء من AppointmentModel
  factory AppointmentDetailsModel.fromAppointment(
    AppointmentModel appointment,
  ) {
    final now = DateTime.now();
    final appointmentDateTime = DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
      int.parse(appointment.time.split(':')[0]),
      int.parse(appointment.time.split(':')[1]),
    );

    final isUpcoming = appointmentDateTime.isAfter(now);
    final List<AppointmentAction> actions = [];

    // تحديد الإجراءات المتاحة
    if (isUpcoming &&
        (appointment.status == AppointmentStatus.upcoming ||
            appointment.status == AppointmentStatus.rescheduled)) {
      actions.add(AppointmentAction.reschedule);
      actions.add(AppointmentAction.cancel);
    }

    if (appointment.status == AppointmentStatus.completed) {
      actions.add(AppointmentAction.viewReceipt);
      actions.add(AppointmentAction.rateDoctor);
    }

    // معلومات إضافية
    final Map<String, String> additionalInfo = {};

    if (appointment.notes != null && appointment.notes!.isNotEmpty) {
      additionalInfo['الملاحظات'] = appointment.notes!;
    }

    if (appointment.rescheduledBy != null) {
      additionalInfo['تم إعادة الجدولة بواسطة'] = appointment.rescheduledBy!;
    }

    if (appointment.cancelledBy != null) {
      additionalInfo['تم الإلغاء بواسطة'] = appointment.cancelledBy!;
    }

    // تاريخ التغييرات
    final List<AppointmentHistoryItem> history = [];
    history.add(
      AppointmentHistoryItem(
        action: 'تم إنشاء الموعد',
        timestamp: appointment.createdAt,
        details: 'تم حجز الموعد بنجاح',
      ),
    );

    if (appointment.status == AppointmentStatus.rescheduled) {
      history.add(
        AppointmentHistoryItem(
          action: 'تم إعادة جدولة الموعد',
          timestamp: appointment.updatedAt,
          details: 'تم تغيير موعد الحجز',
        ),
      );
    }

    if (appointment.status == AppointmentStatus.cancelled) {
      history.add(
        AppointmentHistoryItem(
          action: 'تم إلغاء الموعد',
          timestamp: appointment.updatedAt,
          details: 'تم إلغاء الموعد',
        ),
      );
    }

    if (appointment.status == AppointmentStatus.completed) {
      history.add(
        AppointmentHistoryItem(
          action: 'تم إكمال الموعد',
          timestamp: appointment.updatedAt,
          details: 'تم إنهاء الموعد بنجاح',
        ),
      );
    }

    return AppointmentDetailsModel(
      appointment: appointment,
      availableActions: actions,
      additionalInfo: additionalInfo,
      showRescheduleHistory:
          appointment.status == AppointmentStatus.rescheduled,
      history: history,
    );
  }

  /// نسخ مع تعديل
  AppointmentDetailsModel copyWith({
    AppointmentModel? appointment,
    List<AppointmentAction>? availableActions,
    Map<String, String>? additionalInfo,
    bool? showRescheduleHistory,
    List<AppointmentHistoryItem>? history,
  }) {
    return AppointmentDetailsModel(
      appointment: appointment ?? this.appointment,
      availableActions: availableActions ?? this.availableActions,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      showRescheduleHistory:
          showRescheduleHistory ?? this.showRescheduleHistory,
      history: history ?? this.history,
    );
  }

  /// التحقق من وجود إجراء معين
  bool hasAction(AppointmentAction action) {
    return availableActions.contains(action);
  }

  /// الحصول على عدد الإجراءات المتاحة
  int get actionsCount => availableActions.length;

  /// التحقق من وجود معلومات إضافية
  bool get hasAdditionalInfo => additionalInfo.isNotEmpty;

  /// التحقق من وجود إجراءات متاحة
  bool get hasAvailableActions => availableActions.isNotEmpty;

  @override
  String toString() {
    return 'AppointmentDetailsModel(appointment: ${appointment.id}, actions: ${availableActions.length}, additionalInfo: ${additionalInfo.length})';
  }
}

/// الإجراءات المتاحة للموعد
enum AppointmentAction {
  reschedule,
  cancel,
  viewReceipt,
  rateDoctor,
  contactDoctor,
  getDirections,
}

/// عنصر تاريخ الموعد
class AppointmentHistoryItem extends Equatable {
  final String action;
  final DateTime timestamp;
  final String details;

  const AppointmentHistoryItem({
    required this.action,
    required this.timestamp,
    required this.details,
  });

  @override
  List<Object?> get props => [action, timestamp, details];

  @override
  String toString() {
    return 'AppointmentHistoryItem(action: $action, timestamp: $timestamp, details: $details)';
  }
}

/// امتداد للإجراءات
extension AppointmentActionExtension on AppointmentAction {
  String get displayName {
    switch (this) {
      case AppointmentAction.reschedule:
        return 'إعادة جدولة';
      case AppointmentAction.cancel:
        return 'إلغاء الموعد';
      case AppointmentAction.viewReceipt:
        return 'عرض الإيصال';
      case AppointmentAction.rateDoctor:
        return 'تقييم الطبيب';
      case AppointmentAction.contactDoctor:
        return 'التواصل مع الطبيب';
      case AppointmentAction.getDirections:
        return 'الحصول على الاتجاهات';
    }
  }

  String get iconName {
    switch (this) {
      case AppointmentAction.reschedule:
        return 'schedule';
      case AppointmentAction.cancel:
        return 'cancel';
      case AppointmentAction.viewReceipt:
        return 'receipt';
      case AppointmentAction.rateDoctor:
        return 'star';
      case AppointmentAction.contactDoctor:
        return 'phone';
      case AppointmentAction.getDirections:
        return 'directions';
    }
  }
}
