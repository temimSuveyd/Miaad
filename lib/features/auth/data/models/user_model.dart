import 'package:equatable/equatable.dart';

// نموذج المستخدم
class UserModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final String? imageUrl;
  final String city;
  final DateTime? dateOfBirth;
  final String? gender;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.imageUrl,
    required this.city,
    this.dateOfBirth,
    this.gender,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    imageUrl,
    city,
    dateOfBirth,
    gender,
  ];

  // تحويل من JSON إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['full_name'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      city: json['city'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : json['birthday'] != null
              ? DateTime.parse(json['birthday'] as String)
              : null,
      gender: json['gender'] as String?,
    );
  }

  // تحويل من UserModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'phone': phone,
      // 'image_url': imageUrl,
      'city': city,
      'birthday': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }

  // نسخ الكائن مع تعديل بعض الخصائص
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    String? city,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
