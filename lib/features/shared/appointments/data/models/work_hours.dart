import 'package:equatable/equatable.dart';

/// نموذج ساعات العمل
/// Work Hours Model
class WorkHours extends Equatable {
  final Map<String, List<String>> days;

  const WorkHours({required this.days});

  @override
  List<Object?> get props => [days];

  /// إنشاء من JSON
  factory WorkHours.fromJson(Map<String, dynamic> json) {
    final daysData = json['days'] as Map<String, dynamic>;
    final Map<String, List<String>> days = {};

    daysData.forEach((key, value) {
      days[key] = List<String>.from(value as List);
    });

    return WorkHours(days: days);
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'days': days};
  }

  /// الحصول على الأوقات المتاحة ليوم معين
  List<String> getTimeSlotsForDay(String dayKey) {
    return days[dayKey] ?? [];
  }

  /// التحقق من توفر وقت معين في يوم معين
  bool isTimeAvailable(String dayKey, String time) {
    return days[dayKey]?.contains(time) ?? false;
  }

  /// الحصول على مفتاح اليوم من DateTime
  static String getDayKey(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  /// الحصول على الأوقات المتاحة لتاريخ معين
  List<String> getTimeSlotsForDate(DateTime date) {
    final dayKey = getDayKey(date);
    return getTimeSlotsForDay(dayKey);
  }

  /// التحقق من كون اليوم يوم عمل
  bool isWorkingDay(DateTime date) {
    final dayKey = getDayKey(date);
    return days.containsKey(dayKey) && days[dayKey]!.isNotEmpty;
  }

  /// الحصول على جميع أيام العمل
  List<String> get workingDays => days.keys.toList();

  /// الحصول على إجمالي عدد الأوقات المتاحة
  int get totalTimeSlots {
    return days.values.fold(0, (sum, times) => sum + times.length);
  }

  /// نسخ مع تعديل
  WorkHours copyWith({Map<String, List<String>>? days}) {
    return WorkHours(days: days ?? this.days);
  }

  @override
  String toString() {
    return 'WorkHours(days: $days)';
  }
}
