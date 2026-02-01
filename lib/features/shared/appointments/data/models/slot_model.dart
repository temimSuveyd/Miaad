import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// نموذج الوقت المتاح (Slot) - نظام الحجز الجديد
/// Available Slot Model - New Booking System
class SlotModel extends Equatable {
  final String? id;
  final String doctorId;
  final DateTime slotDate;
  final String slotTime;
  final SlotStatus? status;
  final String? appointmentId;
  final String? bookedBy;
  final DateTime? bookedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? doctorName;
  final String? hospital;
  final String? specialityName;

  const SlotModel({
    this.id,
    required this.doctorId,
    required this.slotDate,
    required this.slotTime,
    this.status,
    this.appointmentId,
    this.bookedBy,
    this.bookedAt,
     this.createdAt,
    required this.updatedAt,
    this.doctorName,
    this.hospital,
    this.specialityName,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        slotDate,
        slotTime,
        status,
        appointmentId,
        bookedBy,
        bookedAt,
        createdAt,
        updatedAt,
        doctorName,
        hospital,
        specialityName,
      ];

  /// تحويل من JSON إلى SlotModel
  /// Convert from JSON to SlotModel
  factory SlotModel.fromJson(dynamic json) {
    log('SlotModel.fromJson: $json');
    
    return SlotModel(
      id: json['slot_id'] as String?,
      doctorId: json['doctor_id'] as String,
      slotDate: DateTime.parse(json['slot_date'] as String),
      slotTime: json['slot_time'] as String,
      status: _statusFromString(json['status'] as String?),
      appointmentId: json['appointment_id'] as String?,
      bookedBy: json['booked_by'] as String?,
      bookedAt: json['booked_at'] != null 
          ? DateTime.parse(json['booked_at'] as String) 
          : null,
      // Bu alanlar veritabanından gelmiyor, null olarak kalacak
      doctorName: null,
      hospital: null,
      specialityName: null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  /// تحويل من SlotModel إلى JSON
  /// Convert from SlotModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doctor_id': doctorId,
      'slot_date': slotDate.toIso8601String().split('T')[0],
      'slot_time': slotTime,
      'status': status != null ? _statusToString(status!) : 'available',
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (bookedBy != null) 'booked_by': bookedBy,
      if (bookedAt != null) 'booked_at': bookedAt!.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// نسخ الكائن مع تعديل بعض الخصائص
  /// Copy object with modified properties
  SlotModel copyWith({
    String? id,
    String? doctorId,
    DateTime? slotDate,
    String? slotTime,
    SlotStatus? status,
    String? appointmentId,
    String? bookedBy,
    DateTime? bookedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? doctorName,
    String? hospital,
    String? specialityName,
  }) {
    return SlotModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      slotDate: slotDate ?? this.slotDate,
      slotTime: slotTime ?? this.slotTime,
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      bookedBy: bookedBy ?? this.bookedBy,
      bookedAt: bookedAt ?? this.bookedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      specialityName: specialityName ?? this.specialityName,
    );
  }

  /// Helper method to convert string to status enum
  static SlotStatus _statusFromString(String? status) {
    if (status == null || status.isEmpty) {
      return SlotStatus.available; // Default status
    }
    
    switch (status.toLowerCase()) {
      case 'available':
        return SlotStatus.available;
      case 'booked':
        return SlotStatus.booked;
      case 'completed':
        return SlotStatus.completed;
      case 'cancelled':
        return SlotStatus.cancelled;
      default:
        return SlotStatus.available; // Default for unknown status
    }
  }

  /// Helper method to convert status enum to string
  static String _statusToString(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return 'available';
      case SlotStatus.booked:
        return 'booked';
      case SlotStatus.completed:
        return 'completed';
      case SlotStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  String toString() {
    return 'SlotModel(id: $id, doctorId: $doctorId, slotDate: $slotDate, slotTime: $slotTime, status: $status, doctorName: $doctorName)';
  }

  /// Status helper methods for UI
  Color getStatusColor() {
    switch (status ?? SlotStatus.available) {
      case SlotStatus.available:
        return const Color(0xFF4CAF50); // Green
      case SlotStatus.booked:
        return const Color(0xFF2196F3); // Blue
      case SlotStatus.completed:
        return const Color(0xFF9E9E9E); // Grey
      case SlotStatus.cancelled:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData getStatusIcon() {
    switch (status ?? SlotStatus.available) {
      case SlotStatus.available:
        return Icons.access_time;
      case SlotStatus.booked:
        return Icons.event_available;
      case SlotStatus.completed:
        return Icons.check_circle;
      case SlotStatus.cancelled:
        return Icons.cancel;
    }
  }

  String getStatusText() {
    switch (status ?? SlotStatus.available) {
      case SlotStatus.available:
        return 'متاح';
      case SlotStatus.booked:
        return 'محجوز';
      case SlotStatus.completed:
        return 'مكتمل';
      case SlotStatus.cancelled:
        return 'ملغي';
    }
  }

  /// Check if slot is available for booking
  bool get isAvailable => (status ?? SlotStatus.available) == SlotStatus.available;

  /// Check if slot is in the past
  bool get isPast {
    final slotDateTime = DateTime(
      slotDate.year,
      slotDate.month,
      slotDate.day,
      int.parse(slotTime.split(':')[0]),
      int.parse(slotTime.split(':')[1]),
    );
    return slotDateTime.isBefore(DateTime.now());
  }

  /// Check if slot is today
  bool get isToday {
    final now = DateTime.now();
    return slotDate.year == now.year &&
        slotDate.month == now.month &&
        slotDate.day == now.day;
  }

  /// Check if slot is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return slotDate.year == tomorrow.year &&
        slotDate.month == tomorrow.month &&
        slotDate.day == tomorrow.day;
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

    return '${slotDate.day} ${months[slotDate.month - 1]} ${slotDate.year}';
  }

  /// Get formatted time string
  String get formattedTime {
    final parts = slotTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) return '12:$minute ص';
    if (hour < 12) return '$hour:$minute ص';
    if (hour == 12) return '12:$minute م';
    return '${hour - 12}:$minute م';
  }

  /// Get formatted date and time string
  String get formattedDateTime {
    return '$formattedDate - $formattedTime';
  }
}

/// Enum for slot status
enum SlotStatus { available, booked, completed, cancelled }

/// Extension for status display
extension SlotStatusExtension on SlotStatus {
  String get displayName {
    switch (this) {
      case SlotStatus.available:
        return 'متاح';
      case SlotStatus.booked:
        return 'محجوز';
      case SlotStatus.completed:
        return 'مكتمل';
      case SlotStatus.cancelled:
        return 'ملغي';
    }
  }

  bool get isBookable => this == SlotStatus.available;

  bool get isOccupied => this == SlotStatus.booked || this == SlotStatus.completed;

  bool get isFinished => this == SlotStatus.completed || this == SlotStatus.cancelled;

  Color get color {
    switch (this) {
      case SlotStatus.available:
        return const Color(0xFF4CAF50);
      case SlotStatus.booked:
        return const Color(0xFF2196F3);
      case SlotStatus.completed:
        return const Color(0xFF9E9E9E);
      case SlotStatus.cancelled:
        return const Color(0xFFF44336);
    }
  }
}

