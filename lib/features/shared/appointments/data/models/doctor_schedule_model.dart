import 'package:equatable/equatable.dart';

/// نموذج جدول عمل الطبيب
/// Doctor Schedule Model
class DoctorScheduleModel extends Equatable {
  final String? id;
  final String doctorId;
  final int dayOfWeek; // 1=Monday, 7=Sunday
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DoctorScheduleModel({
    this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.slotDurationMinutes = 60,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        dayOfWeek,
        startTime,
        endTime,
        slotDurationMinutes,
        isActive,
        createdAt,
        updatedAt,
      ];

  /// تحويل من JSON إلى DoctorScheduleModel
  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      id: json['id'] as String?,
      doctorId: json['doctor_id'] as String,
      dayOfWeek: int.parse(json['day_of_week'].toString()),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slotDurationMinutes: int.parse(json['slot_duration_minutes'].toString()),
      isActive: json['is_active'].toString().toLowerCase() == 'true',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل من DoctorScheduleModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doctor_id': doctorId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'slot_duration_minutes': slotDurationMinutes,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// الحصول على اسم اليوم بالعربية
  String get dayNameArabic {
    switch (dayOfWeek) {
      case 1: return 'الإثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      case 7: return 'الأحد';
      default: return 'غير معروف';
    }
  }

  /// الحصول على اسم اليوم بالإنجليزية
  String get dayNameEnglish {
    switch (dayOfWeek) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'DoctorScheduleModel(id: $id, doctorId: $doctorId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, isActive: $isActive)';
  }
}
