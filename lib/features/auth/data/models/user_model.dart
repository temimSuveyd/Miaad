import 'package:equatable/equatable.dart';

// نموذج المستخدم
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.address,
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
    address,
    dateOfBirth,
    gender,
  ];

  // تحويل من JSON إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
    );
  }

  // تحويل من UserModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
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
    String? address,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

}
