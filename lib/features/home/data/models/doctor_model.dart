import 'package:flutter/material.dart';

class DoctorModel {
  final int id;
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorModel &&
        other.id == id &&
        other.name == name &&
        other.specialty == specialty &&
        other.rating == rating &&
        other.reviews == reviews &&
        other.price == price &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      specialty.hashCode ^
      rating.hashCode ^
      reviews.hashCode ^
      price.hashCode ^
      imageUrl.hashCode;

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      price: json['price'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

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

  factory DoctorModel.fromDoctor(DoctorModel doctor) {
    return DoctorModel(
      id: doctor.id,
      name: doctor.name,
      specialty: doctor.specialty,
      rating: doctor.rating,
      reviews: doctor.reviews,
      price: doctor.price,
      imageUrl: doctor.imageUrl,
    );
  }

  DoctorModel copyWith({
    int? id,
    String? name,
    String? specialty,
    double? rating,
    int? reviews,
    String? price,
    String? imageUrl,
    Color? backgroundColor,
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
