// أداة تنسيق التاريخ
class DateFormatter {
  // قائمة الأشهر المختصرة
  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // قائمة الأشهر الكاملة
  static const List<String> _monthsFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // تنسيق التاريخ: MMM dd (مثل: Jan 15)
  static String formatShort(DateTime date) {
    return '${_monthsShort[date.month - 1]} ${date.day}';
  }

  // تنسيق التاريخ: MMMM dd, yyyy (مثل: January 15, 2024)
  static String formatFull(DateTime date) {
    return '${_monthsFull[date.month - 1]} ${date.day}, ${date.year}';
  }

  // تنسيق التاريخ: dd/MM/yyyy (مثل: 15/01/2024)
  static String formatNumeric(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // تنسيق التاريخ: yyyy-MM-dd (مثل: 2024-01-15)
  static String formatISO(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // تنسيق التاريخ مع اسم اليوم: Mon, Jan 15 (مثل: Mon, Jan 15)
  static String formatWithDay(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = days[date.weekday - 1];
    return '$dayName, ${formatShort(date)}';
  }

  // تنسيق الوقت: HH:mm (مثل: 14:30)
  static String formatTime24(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // تنسيق الوقت: hh:mm AM/PM (مثل: 02:30 PM)
  static String formatTime12(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }

  // تنسيق التاريخ والوقت: MMM dd, HH:mm (مثل: Jan 15, 14:30)
  static String formatDateTime(DateTime date) {
    return '${formatShort(date)}, ${formatTime24(date)}';
  }

  // الحصول على الفرق بين تاريخين بصيغة نصية
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // التحقق من أن التاريخ هو اليوم
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // التحقق من أن التاريخ هو الغد
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // التحقق من أن التاريخ هو الأمس
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // تنسيق التاريخ بشكل ذكي (Today, Tomorrow, Yesterday, أو التاريخ)
  static String formatSmart(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return formatShort(date);
    }
  }
}
