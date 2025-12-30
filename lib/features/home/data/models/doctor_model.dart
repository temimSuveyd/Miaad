import 'package:equatable/equatable.dart';

// نموذج الطبيب - يستخدم في طبقة Data والـ UI
class DoctorModel extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String price;
  final String imageUrl;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    rating,
    reviews,
    price,
    imageUrl,
  ];

  // تحويل من JSON إلى DoctorModel
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      price: json['price'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // تحويل من DoctorModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'reviews': reviews,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // نسخ الكائن مع تعديل بعض الخصائص
  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    double? rating,
    int? reviews,
    String? price,
    String? imageUrl,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
