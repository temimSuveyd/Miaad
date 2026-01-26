class WorkingHoursParser {
  // Format working hours from Map to Arabic string
  static String formatWorkingHours(Map<String, dynamic>? workingHoursMap) {
    if (workingHoursMap == null || workingHoursMap.isEmpty) return 'غير محدد';

    try {
      final List<String> formattedHours = [];

      workingHoursMap.forEach((key, value) {
        if (key.isNotEmpty && value != null) {
          final day = key.toString();
          final time = value.toString();

          // Translate days to Arabic
          final arabicDay = _translateDayToArabic(day);
          formattedHours.add('$arabicDay: $time');
        }
      });

      return formattedHours.isNotEmpty ? formattedHours.join(', ') : 'غير محدد';
    } catch (e) {
      return 'غير محدد';
    }
  }

  // Format working hours from Map to Arabic Map
  static Map<String, String> formatWorkingHoursAsMap(
    Map<String, dynamic>? workingHoursMap,
  ) {
    if (workingHoursMap == null || workingHoursMap.isEmpty) {
      return {'غير محدد': 'غير محدد'};
    }

    try {
      final Map<String, String> formattedMap = {};

      workingHoursMap.forEach((key, value) {
        if (key.isNotEmpty && value != null) {
          final day = key.toString();
          final time = value.toString();

          // Translate days to Arabic
          final arabicDay = _translateDayToArabic(day);
          formattedMap[arabicDay] = time;
        }
      });

      return formattedMap.isNotEmpty ? formattedMap : {'غير محدد': 'غير محدد'};
    } catch (e) {
      return {'خطأ': 'خطأ في تحليل البيانات'};
    }
  }

  // Translate days to Arabic
  static String _translateDayToArabic(String day) {
    final dayTranslations = {
      'Mon': 'الاثنين',
      'Tue': 'الثلاثاء',
      'Wed': 'الأربعاء',
      'Thu': 'الخميس',
      'Fri': 'الجمعة',
      'Sat': 'السبت',
      'Sun': 'الأحد',
      'Mon-Fri': 'الاثنين - الجمعة',
      'Sat-Sun': 'السبت - الأحد',
      'Mon-Sat': 'الاثنين - السبت',
      'Sun-Thu': 'الأحد - الخميس',
      'Mon-Wed': 'الاثنين - الأربعاء',
      'Thu-Fri': 'الخميس - الجمعة',
      'Sat-Thu': 'السبت - الخميس',
      'Sun-Fri': 'الأحد - الجمعة',
    };

    return dayTranslations[day] ?? day;
  }
}
