import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppointmentsModel extends Equatable {
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

  const AppointmentsModel({
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
    required this.hospitalName,
    required this.doctorName,
    required this.userName,
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
  ];

  // Factory constructor from JSON
  factory AppointmentsModel.fromJson(dynamic json) {
    return AppointmentsModel(
      id: json['id'] as String,
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
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'doctor_id': doctorId,
      'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      'time': time,
      'status': _statusToString(AppointmentStatus.completed),
      'rescheduled_by': rescheduledBy,
      'cancelled_by': cancelledBy,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with method for immutability
  AppointmentsModel copyWith({
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
  }) {
    return AppointmentsModel(
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
    );
  }

  // Helper method to convert string to status enum
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

  // Helper method to convert status enum to string
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
    return 'AppointmentsModel(id: $id, userId: $userId, doctorId: $doctorId, date: $date, time: $time, status: $status, rescheduledBy: $rescheduledBy, cancelledBy: $cancelledBy, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt , userNaem: $userName , doctorName: $doctorName , hospitalName: $hospitalName)';
  }

  // Status helper methods for UI
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
        return 'Yaklaşan';
      case AppointmentStatus.completed:
        return 'Tamamlandı';
      case AppointmentStatus.cancelled:
        return 'İptal Edildi';
      case AppointmentStatus.rescheduled:
        return 'Ertelendi';
    }
  }
}

// Enum for appointment status
enum AppointmentStatus { upcoming, completed, cancelled, rescheduled }

// Extension for status display
extension AppointmentStatusExtension on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
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
}
