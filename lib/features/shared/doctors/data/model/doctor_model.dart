import 'package:equatable/equatable.dart';

/// نموذج الطبيب المشترك - يستخدم في جميع الميزات
/// Common Doctor Model - Used across all features
class DoctorModel extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String experience;
  final String location;
  final Map<String, dynamic> workingHours;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String? phone;
  final String? email;
  final bool? isAvailable;
  final List<String>? languages;
  final String? bio;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.experience,
    required this.location,
    required this.workingHours,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    this.phone,
    this.email,
    this.isAvailable,
    this.languages,
    this.bio,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    hospital,
    experience,
    location,
    workingHours,
    rating,
    reviewsCount,
    imageUrl,
    phone,
    email,
    isAvailable,
    languages,
    bio,
  ];

  /// تحويل من JSON إلى DoctorModel
  /// Convert from JSON to DoctorModel
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String? ?? json['doctor_id'] as String,
      name: json['name'] as String? ?? json['doctor_name'] as String,
      specialty:
          json['speciality_name'] as String? ?? json['specialty'] as String,
      hospital: json['hospital'] as String,
      experience: json['experience'] as String,
      location: json['location'] as String,
      workingHours: json['working_hours'] as Map<String, dynamic>? ?? {},
      rating:
          (json['rating'] as num?)?.toDouble() ??
          double.tryParse(
            json['avg_review_rating']?.toString() ??
                json['average_rating']?.toString() ??
                '0',
          ) ??
          0.0,
      reviewsCount:
          json['reviews_count'] as int? ??
          json['total_reviews'] as int? ??
          0,
      imageUrl:
          json['doctor_image'] as String? ?? json['image_url'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isAvailable:
          json['is_available'] as bool? ?? json['isAvailable'] as bool?,
      languages: (json['languages'] as List<dynamic>?)?.cast<String>(),
      bio: json['bio'] as String?,
    );
  }

  /// تحويل من DoctorModel إلى JSON
  /// Convert from DoctorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctor_id': id,
      'doctor_name': name,
      'speciality_name': specialty,
      'hospital': hospital,
      'experience': experience,
      'location': location,
      'working_hours': workingHours,
      'avg_review_rating': rating.toString(),
      'total_reviews': reviewsCount,
      'image_url': imageUrl,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (isAvailable != null) 'is_available': isAvailable,
      if (languages != null) 'languages': languages,
      if (bio != null) 'bio': bio,
    };
  }

  /// نسخ الكائن مع تعديل بعض الخصائص
  /// Copy object with modified properties
  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? hospital,
    String? experience,
    String? location,
    Map<String, dynamic>? workingHours,
    double? rating,
    int? reviewsCount,
    String? imageUrl,
    String? phone,
    String? email,
    bool? isAvailable,
    List<String>? languages,
    String? bio,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      hospital: hospital ?? this.hospital,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      workingHours: workingHours ?? this.workingHours,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isAvailable: isAvailable ?? this.isAvailable,
      languages: languages ?? this.languages,
      bio: bio ?? this.bio,
    );
  }

  /// Helper getters for UI compatibility
  String get price => '${_getPriceForSpecialty(specialty)} ريال/ساعة';
  int get reviews => reviewsCount;
  bool get available => isAvailable ?? true;

  /// Generate realistic price based on specialty
  static String _getPriceForSpecialty(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'جراحة الأعصاب':
      case 'neurosurgery':
        return '150';
      case 'أمراض القلب':
      case 'cardiology':
        return '120';
      case 'أمراض النساء والتوليد':
      case 'gynecology':
        return '100';
      case 'طب العيون':
      case 'ophthalmology':
        return '80';
      case 'الطب النفسي':
      case 'psychiatry':
        return '90';
      case 'جراحة العظام':
      case 'orthopedics':
        return '110';
      case 'جراحة الأسنان':
      case 'dentistry':
        return '70';
      case 'الأمراض الجلدية':
      case 'dermatology':
        return '85';
      case 'طب الأطفال':
      case 'pediatrics':
        return '75';
      case 'الطب الباطني':
      case 'internal medicine':
        return '95';
      default:
        return '60';
    }
  }

  /// Get formatted experience years
  String get experienceYears {
    final RegExp yearRegex = RegExp(r'(\d+)');
    final match = yearRegex.firstMatch(experience);

    if (match != null) {
      final years = int.parse(match.group(1)!);
      return '$years سنة';
    }

    return experience;
  }

  /// Check if doctor is working today
  bool get isWorkingToday {
    final today = DateTime.now().weekday;
    final dayNames = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };

    final todayName = dayNames[today];
    return workingHours.containsKey(todayName) &&
        workingHours[todayName] != null &&
        workingHours[todayName].toString().isNotEmpty;
  }

  /// Get today's working hours
  String get todayWorkingHours {
    if (!isWorkingToday) return 'غير متاح اليوم';

    final today = DateTime.now().weekday;
    final dayNames = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };

    final todayName = dayNames[today];
    return workingHours[todayName]?.toString() ?? 'غير محدد';
  }
}
