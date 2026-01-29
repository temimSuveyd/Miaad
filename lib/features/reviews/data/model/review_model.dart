import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String? reviewId;
  final String doctorId;
  final String userId;
  final String? userFullName;
  final String? userEmail;
  final String? userPhone;
  final String comment;
  final double rating;
  final DateTime reviewCreatedAt;

  const ReviewModel({
    this.reviewId,
    required this.doctorId,
    required this.userId,
    this.userFullName,
    this.userEmail,
    this.userPhone,
    required this.comment,
    required this.rating,
    required this.reviewCreatedAt,
  });

  // Helper getters for backward compatibility
  String? get userName => userFullName;
  String? get userImageUrl => null; // Not available in current API response

  @override
  List<Object?> get props => [
    reviewId,
    doctorId,
    userId,
    userFullName,
    userEmail,
    userPhone,
    comment,
    rating,
    reviewCreatedAt,
  ];

  factory ReviewModel.fromJson({
    required Map<String, dynamic> json,
    required bool isViewTaple,
  }) {
    if (isViewTaple) {
      return ReviewModel(
        reviewId: json["review_id"] as String?,
        doctorId: json['doctor_id'] as String,
        userId: json['user_id'] as String,
        userFullName: json['user_full_name'] as String?,
        userEmail: json['user_email'] as String?,
        userPhone: json['user_phone'] as String?,
        comment: json['comment'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCreatedAt: DateTime.parse(json['review_created_at'] as String),
      );
    } else {
      return ReviewModel(
        reviewId: json["id"] as String?,
        doctorId: json['doctor_id'] as String,
        userId: json['user_id'] as String,
        comment: json['comment'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCreatedAt: DateTime.parse(json['created_at'] as String),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (reviewId != null) 'id': reviewId,
      'doctor_id': doctorId,
      'user_id': userId,
      'comment': comment,
      'rating': rating.toInt(),
      'created_at': reviewCreatedAt.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? reviewId,
    String? doctorId,
    String? userId,
    String? userFullName,
    String? userEmail,
    String? userPhone,
    String? comment,
    double? rating,
    DateTime? reviewCreatedAt,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      doctorId: doctorId ?? this.doctorId,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      reviewCreatedAt: reviewCreatedAt ?? this.reviewCreatedAt,
    );
  }

  // Helper methods for review management
  bool isOwnedBy(String currentUserId) => userId == currentUserId;

  String get displayName => userFullName ?? 'مستخدم مجهول';

  String get displayImageUrl => '';

  String get ratingText {
    return switch (rating.toInt()) {
      1 => 'سيء جداً',
      2 => 'سيء',
      3 => 'متوسط',
      4 => 'جيد',
      5 => 'ممتاز',
      _ => 'ممتاز',
    };
  }
}
