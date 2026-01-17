/// Syrian cities data
class SyrianCity {
  final String nameAr;
  final String nameEn;
  final String governorate;

  const SyrianCity({
    required this.nameAr,
    required this.nameEn,
    required this.governorate,
  });
}

/// List of all Syrian cities
class SyrianCities {
  static const List<SyrianCity> cities = [
    // دمشق - Damascus
    SyrianCity(nameAr: 'دمشق', nameEn: 'Damascus', governorate: 'دمشق'),
    SyrianCity(nameAr: 'جرمانا', nameEn: 'Jaramana', governorate: 'دمشق'),
    SyrianCity(nameAr: 'دوما', nameEn: 'Douma', governorate: 'دمشق'),
    SyrianCity(nameAr: 'داريا', nameEn: 'Daraya', governorate: 'دمشق'),
    SyrianCity(nameAr: 'القطيفة', nameEn: 'Al-Qutayfah', governorate: 'دمشق'),
    SyrianCity(nameAr: 'التل', nameEn: 'Al-Tall', governorate: 'دمشق'),
    SyrianCity(nameAr: 'يبرود', nameEn: 'Yabroud', governorate: 'دمشق'),
    SyrianCity(nameAr: 'النبك', nameEn: 'Al-Nabek', governorate: 'دمشق'),

    // حلب - Aleppo
    SyrianCity(nameAr: 'حلب', nameEn: 'Aleppo', governorate: 'حلب'),
    SyrianCity(nameAr: 'منبج', nameEn: 'Manbij', governorate: 'حلب'),
    SyrianCity(nameAr: 'الباب', nameEn: 'Al-Bab', governorate: 'حلب'),
    SyrianCity(nameAr: 'جرابلس', nameEn: 'Jarabulus', governorate: 'حلب'),
    SyrianCity(nameAr: 'عفرين', nameEn: 'Afrin', governorate: 'حلب'),
    SyrianCity(nameAr: 'عزاز', nameEn: 'Azaz', governorate: 'حلب'),
    SyrianCity(nameAr: 'اعزاز', nameEn: 'Azaz', governorate: 'حلب'),

    // حمص - Homs
    SyrianCity(nameAr: 'حمص', nameEn: 'Homs', governorate: 'حمص'),
    SyrianCity(nameAr: 'تدمر', nameEn: 'Palmyra', governorate: 'حمص'),
    SyrianCity(nameAr: 'القصير', nameEn: 'Al-Qusayr', governorate: 'حمص'),
    SyrianCity(nameAr: 'الرستن', nameEn: 'Ar-Rastan', governorate: 'حمص'),
    SyrianCity(nameAr: 'تلبيسة', nameEn: 'Talbiseh', governorate: 'حمص'),

    // حماة - Hama
    SyrianCity(nameAr: 'حماة', nameEn: 'Hama', governorate: 'حماة'),
    SyrianCity(nameAr: 'السلمية', nameEn: 'Salamiyah', governorate: 'حماة'),
    SyrianCity(nameAr: 'مصياف', nameEn: 'Masyaf', governorate: 'حماة'),
    SyrianCity(nameAr: 'محردة', nameEn: 'Mahardah', governorate: 'حماة'),

    // اللاذقية - Latakia
    SyrianCity(nameAr: 'اللاذقية', nameEn: 'Latakia', governorate: 'اللاذقية'),
    SyrianCity(nameAr: 'جبلة', nameEn: 'Jableh', governorate: 'اللاذقية'),
    SyrianCity(nameAr: 'القرداحة', nameEn: 'Al-Qardaha', governorate: 'اللاذقية'),

    // طرطوس - Tartus
    SyrianCity(nameAr: 'طرطوس', nameEn: 'Tartus', governorate: 'طرطوس'),
    SyrianCity(nameAr: 'بانياس', nameEn: 'Baniyas', governorate: 'طرطوس'),
    SyrianCity(nameAr: 'صافيتا', nameEn: 'Safita', governorate: 'طرطوس'),
    SyrianCity(nameAr: 'دريكيش', nameEn: 'Dreikish', governorate: 'طرطوس'),

    // إدلب - Idlib
    SyrianCity(nameAr: 'إدلب', nameEn: 'Idlib', governorate: 'إدلب'),
    SyrianCity(nameAr: 'معرة النعمان', nameEn: 'Maarat al-Numan', governorate: 'إدلب'),
    SyrianCity(nameAr: 'جسر الشغور', nameEn: 'Jisr al-Shughur', governorate: 'إدلب'),
    SyrianCity(nameAr: 'سراقب', nameEn: 'Saraqib', governorate: 'إدلب'),
    SyrianCity(nameAr: 'أريحا', nameEn: 'Ariha', governorate: 'إدلب'),

    // درعا - Daraa
    SyrianCity(nameAr: 'درعا', nameEn: 'Daraa', governorate: 'درعا'),
    SyrianCity(nameAr: 'إزرع', nameEn: 'Izra', governorate: 'درعا'),
    SyrianCity(nameAr: 'الصنمين', nameEn: 'Al-Sanamayn', governorate: 'درعا'),
    SyrianCity(nameAr: 'نوى', nameEn: 'Nawa', governorate: 'درعا'),

    // السويداء - As-Suwayda
    SyrianCity(nameAr: 'السويداء', nameEn: 'As-Suwayda', governorate: 'السويداء'),
    SyrianCity(nameAr: 'صلخد', nameEn: 'Salkhad', governorate: 'السويداء'),
    SyrianCity(nameAr: 'شهبا', nameEn: 'Shahba', governorate: 'السويداء'),

    // القنيطرة - Quneitra
    SyrianCity(nameAr: 'القنيطرة', nameEn: 'Quneitra', governorate: 'القنيطرة'),
    SyrianCity(nameAr: 'خان أرنبة', nameEn: 'Khan Arnabah', governorate: 'القنيطرة'),

    // دير الزور - Deir ez-Zor
    SyrianCity(nameAr: 'دير الزور', nameEn: 'Deir ez-Zor', governorate: 'دير الزور'),
    SyrianCity(nameAr: 'البوكمال', nameEn: 'Al-Bukamal', governorate: 'دير الزور'),
    SyrianCity(nameAr: 'الميادين', nameEn: 'Al-Mayadin', governorate: 'دير الزور'),

    // الرقة - Raqqa
    SyrianCity(nameAr: 'الرقة', nameEn: 'Raqqa', governorate: 'الرقة'),
    SyrianCity(nameAr: 'تل أبيض', nameEn: 'Tell Abyad', governorate: 'الرقة'),

    // الحسكة - Al-Hasakah
    SyrianCity(nameAr: 'الحسكة', nameEn: 'Al-Hasakah', governorate: 'الحسكة'),
    SyrianCity(nameAr: 'القامشلي', nameEn: 'Qamishli', governorate: 'الحسكة'),
    SyrianCity(nameAr: 'رأس العين', nameEn: 'Ras al-Ayn', governorate: 'الحسكة'),
    SyrianCity(nameAr: 'المالكية', nameEn: 'Al-Malikiyah', governorate: 'الحسكة'),
  ];

  /// Get cities grouped by governorate
  static Map<String, List<SyrianCity>> get citiesByGovernorate {
    final Map<String, List<SyrianCity>> grouped = {};
    for (var city in cities) {
      if (!grouped.containsKey(city.governorate)) {
        grouped[city.governorate] = [];
      }
      grouped[city.governorate]!.add(city);
    }
    return grouped;
  }

  /// Get all governorates
  static List<String> get governorates {
    return citiesByGovernorate.keys.toList();
  }

  /// Search cities by name
  static List<SyrianCity> searchCities(String query) {
    if (query.isEmpty) return cities;
    final lowerQuery = query.toLowerCase();
    return cities.where((city) {
      return city.nameAr.contains(query) ||
          city.nameEn.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
