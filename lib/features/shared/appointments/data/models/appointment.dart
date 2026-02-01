import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'slot_model.dart';

/// نموذج الموعد المشترك - يستخدم في جميع الميزات
/// Shared Appointment Model - Used across all features
class AppointmentModel extends Equatable {
  final String? id;
  final String userId;
  final String doctorId;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final String? rescheduledBy;
  final String? cancelledBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? hospitalName;
  final String? doctorName;
  final String? userName;
  // معلومات السلوت المرتبط بالموعد
  final String? slotId;
  final SlotModel? slot;

  const AppointmentModel({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    this.rescheduledBy,
    this.cancelledBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.hospitalName,
    this.doctorName,
    this.userName,
    this.slotId,
    this.slot,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    doctorId,
    date,
    time,
    status,
    rescheduledBy,
    cancelledBy,
    notes,
    createdAt,
    updatedAt,
    hospitalName,
    doctorName,
    userName,
    slotId,
    slot,
  ];

  /// تحويل من JSON إلى AppointmentsModel
  /// Convert from JSON to AppointmentsModel
  factory AppointmentModel.fromJson(dynamic json) {
    return AppointmentModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      status: _statusFromString(json['status'] as String),
      rescheduledBy: json['rescheduled_by'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      notes: json['notes'] as String?,
      hospitalName: json['hospital'] as String?,
      doctorName: json['doctor_name'] as String?,
      userName: json['user_name'] as String?,
      slotId: json['slot_id'] as String?,
      slot: json['slot'] != null ? SlotModel.fromJson(json['slot']) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل من AppointmentsModel إلى JSON
  /// Convert from AppointmentsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'doctor_id': doctorId,
      'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      'time': time,
      'status': _statusToString(status),
      if (rescheduledBy != null) 'rescheduled_by': rescheduledBy,
      if (cancelledBy != null) 'cancelled_by': cancelledBy,
      if (notes != null) 'notes': notes,
      if (slotId != null) 'slot_id': slotId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// نسخ الكائن مع تعديل بعض الخصائص
  /// Copy object with modified properties
  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? doctorId,
    DateTime? date,
    String? time,
    AppointmentStatus? status,
    String? rescheduledBy,
    String? cancelledBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? doctorName,
    String? userName,
    String? hospitalName,
    String? slotId,
    SlotModel? slot,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      rescheduledBy: rescheduledBy ?? this.rescheduledBy,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      userName: userName ?? this.userName,
      slotId: slotId ?? this.slotId,
      slot: slot ?? this.slot,
    );
  }

  /// Helper method to convert string to status enum
  static AppointmentStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppointmentStatus.upcoming;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      default:
        return AppointmentStatus.upcoming;
    }
  }

  /// Helper method to convert status enum to string
  static String _statusToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'upcoming';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.rescheduled:
        return 'rescheduled';
    }
  }

  @override
  String toString() {
    return 'AppointmentsModel(id: $id, userId: $userId, doctorId: $doctorId, date: $date, time: $time, status: $status, doctorName: $doctorName, hospitalName: $hospitalName, slotId: $slotId)';
  }

  /// Status helper methods for UI
  Color getStatusColor() {
    switch (status) {
      case AppointmentStatus.upcoming:
        return const Color(0xFF2196F3); // Blue
      case AppointmentStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case AppointmentStatus.cancelled:
        return const Color(0xFFF44336); // Red
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFF9800); // Orange
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case AppointmentStatus.upcoming:
        return Icons.schedule;
      case AppointmentStatus.completed:
        return Icons.check_circle;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
      case AppointmentStatus.rescheduled:
        return Icons.update;
    }
  }

  String getStatusText() {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'قادم';
      case AppointmentStatus.completed:
        return 'مكتمل';
      case AppointmentStatus.cancelled:
        return 'ملغي';
      case AppointmentStatus.rescheduled:
        return 'معاد جدولته';
    }
  }

  /// Check if appointment is in the past
  bool get isPast {
    final appointmentDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
    return appointmentDateTime.isBefore(DateTime.now());
  }

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if appointment is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get formatted date string
  String get formattedDate {
    if (isToday) return 'اليوم';
    if (isTomorrow) return 'غداً';

    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get formatted time string
  String get formattedTime {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) return '12:$minute ص';
    if (hour < 12) return '$hour:$minute ص';
    if (hour == 12) return '12:$minute م';
    return '${hour - 12}:$minute م';
  }

  /// Check if appointment has slot information
  bool get hasSlot => slot != null || slotId != null;

  /// Get slot duration in minutes (if available)
  int? get slotDuration {
    if (slot != null) {
      // يمكن حساب المدة من بيانات السلوت إذا كانت متاحة
      // مؤقتاً نرجع قيمة افتراضية
      return 60;
    }
    return null;
  }

  /// Check if appointment can be rescheduled (has active slot)
  bool get canBeRescheduled {
    return hasSlot && 
           (status == AppointmentStatus.upcoming || status == AppointmentStatus.rescheduled) &&
           !isPast;
  }

  /// Get appointment type based on slot
  String get appointmentType {
    if (hasSlot) {
      return 'حجز بالسلوت';
    }
    return 'حجز عادي';
  }
}

/// Enum for appointment status
enum AppointmentStatus { upcoming, completed, cancelled, rescheduled }

/// Extension for status display
extension AppointmentStatusExtension on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'قادم';
      case AppointmentStatus.completed:
        return 'مكتمل';
      case AppointmentStatus.cancelled:
        return 'ملغي';
      case AppointmentStatus.rescheduled:
        return 'معاد جدولته';
    }
  }

  bool get isActive {
    return this == AppointmentStatus.upcoming ||
        this == AppointmentStatus.rescheduled;
  }

  bool get isFinished {
    return this == AppointmentStatus.completed ||
        this == AppointmentStatus.cancelled;
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.upcoming:
        return const Color(0xFF2196F3);
      case AppointmentStatus.completed:
        return const Color(0xFF4CAF50);
      case AppointmentStatus.cancelled:
        return const Color(0xFFF44336);
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFF9800);
    }
  }
}
