import 'package:equatable/equatable.dart';
import 'appointment.dart';

/// نموذج استجابة المواعيد
/// Appointment Response Model
class AppointmentResponse extends Equatable {
  final bool success;
  final String message;
  final AppointmentModel? appointment;
  final List<AppointmentModel>? appointments;
  final int? totalCount;

  const AppointmentResponse({
    required this.success,
    required this.message,
    this.appointment,
    this.appointments,
    this.totalCount,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    appointment,
    appointments,
    totalCount,
  ];

  /// تحويل من JSON
  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      appointment: json['appointment'] != null
          ? AppointmentModel.fromJson(json['appointment'])
          : null,
      appointments: json['appointments'] != null
          ? (json['appointments'] as List)
                .map((item) => AppointmentModel.fromJson(item))
                .toList()
          : null,
      totalCount: json['total_count'] as int?,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (appointment != null) 'appointment': appointment!.toJson(),
      if (appointments != null)
        'appointments': appointments!.map((a) => a.toJson()).toList(),
      if (totalCount != null) 'total_count': totalCount,
    };
  }

  /// نسخ مع تعديل
  AppointmentResponse copyWith({
    bool? success,
    String? message,
    AppointmentModel? appointment,
    List<AppointmentModel>? appointments,
    int? totalCount,
  }) {
    return AppointmentResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      appointment: appointment ?? this.appointment,
      appointments: appointments ?? this.appointments,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  /// إنشاء استجابة نجح
  factory AppointmentResponse.success({
    String message = 'تم بنجاح',
    AppointmentModel? appointment,
    List<AppointmentModel>? appointments,
    int? totalCount,
  }) {
    return AppointmentResponse(
      success: true,
      message: message,
      appointment: appointment,
      appointments: appointments,
      totalCount: totalCount,
    );
  }

  /// إنشاء استجابة خطأ
  factory AppointmentResponse.error(String message) {
    return AppointmentResponse(success: false, message: message);
  }

  @override
  String toString() {
    return 'AppointmentResponse(success: $success, message: $message, appointment: $appointment, appointments: ${appointments?.length}, totalCount: $totalCount)';
  }
}
