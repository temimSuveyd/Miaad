import 'package:equatable/equatable.dart';
import 'review_model.dart';

// نموذج معلومات الطبيب التفصيلية
class DoctorInfoModel extends Equatable {
  final String aboutText;
  final String workingTime;
  final String strNumber;
  final String practicePlace;
  final String practiceYears;
  final String location;
  final double latitude;
  final double longitude;
  final List<ReviewModel> reviews;

  const DoctorInfoModel({
    required this.aboutText,
    required this.workingTime,
    required this.strNumber,
    required this.practicePlace,
    required this.practiceYears,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.reviews,
  });

  @override
  List<Object?> get props => [
    aboutText,
    workingTime,
    strNumber,
    practicePlace,
    practiceYears,
    location,
    latitude,
    longitude,
    reviews,
  ];

  // تحويل من JSON إلى DoctorInfoModel
  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      aboutText: json['aboutText'] as String,
      workingTime: json['workingTime'] as String,
      strNumber: json['strNumber'] as String,
      practicePlace: json['practicePlace'] as String,
      practiceYears: json['practiceYears'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      reviews: (json['reviews'] as List<dynamic>)
          .map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
          .toList(),
    );
  }

  // تحويل من DoctorInfoModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'aboutText': aboutText,
      'workingTime': workingTime,
      'strNumber': strNumber,
      'practicePlace': practicePlace,
      'practiceYears': practiceYears,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  // نسخ الكائن مع تعديل بعض الخصائص
  DoctorInfoModel copyWith({
    String? aboutText,
    String? workingTime,
    String? strNumber,
    String? practicePlace,
    String? practiceYears,
    String? location,
    double? latitude,
    double? longitude,
    List<ReviewModel>? reviews,
  }) {
    return DoctorInfoModel(
      aboutText: aboutText ?? this.aboutText,
      workingTime: workingTime ?? this.workingTime,
      strNumber: strNumber ?? this.strNumber,
      practicePlace: practicePlace ?? this.practicePlace,
      practiceYears: practiceYears ?? this.practiceYears,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reviews: reviews ?? this.reviews,
    );
  }
}
