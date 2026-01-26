import 'package:equatable/equatable.dart';

// نموذج الطبيب - يستخدم في طبقة Data والـ UI
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
  ];

  // تحويل من JSON إلى DoctorModel (من view)
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['doctor_id'] as String,
      name: json['doctor_name'] as String,
      specialty: json['speciality_name'] as String,
      hospital: json['hospital'] as String,
      experience: json['experience'] as String,
      location: json['location'] as String,
      workingHours: json['working_hours'] as Map<String, dynamic>,
      rating:
          double.tryParse(json['avg_review_rating']?.toString() ?? '0') ?? 0.0,
      reviewsCount: json['total_reviews'] as int? ?? 0,
      imageUrl: json['speciality_name'] as String,
    );
  }

  // تحويل من DoctorModel إلى JSON
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
    };
  }

  // نسخ الكائن مع تعديل بعض الخصائص
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
    );
  }

  // Helper getters for UI compatibility
  String get price => '${_getPriceForSpecialty(specialty)} ريال/ساعة';
  int get reviews => reviewsCount;

  // Generate realistic price based on specialty
  static String _getPriceForSpecialty(String specialty) {
    switch (specialty) {
      case 'جراحة الأعصاب':
        return '150';
      case 'أمراض القلب':
        return '120';
      case 'أمراض النساء والتوليد':
        return '100';
      case 'طب العيون':
        return '80';
      case 'الطب النفسي':
        return '90';
      case 'جراحة العظام':
        return '110';
      case 'جراحة الأسنان':
        return '70';
      case 'الأمراض الجلدية':
        return '85';
      case 'طب الأطفال':
        return '75';
      case 'الطب الباطني':
        return '95';
      default:
        return '60';
    }
  }
}
