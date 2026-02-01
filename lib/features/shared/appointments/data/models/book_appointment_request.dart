import 'package:equatable/equatable.dart';

/// نموذج طلب حجز موعد - البيانات الأساسية فقط
/// Book Appointment Request Model - Basic data only
class BookAppointmentRequest extends Equatable {
  final String userId;
  final String doctorId;
  final DateTime date;
  final String time;

  const BookAppointmentRequest({
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [userId, doctorId, date, time];

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'doctor_id': doctorId,
      'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      'time': time,
      'status': 'upcoming',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  BookAppointmentRequest copyWith({
    String? userId,
    String? doctorId,
    DateTime? date,
    String? time,
  }) {
    return BookAppointmentRequest(
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'BookAppointmentRequest(userId: $userId, doctorId: $doctorId, date: $date, time: $time)';
  }
}
