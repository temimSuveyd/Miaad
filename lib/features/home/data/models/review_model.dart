import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

// نموذج التقييم/المراجعة
class ReviewModel extends Equatable {
  final UserModel user;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.user,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [user, rating, comment, date];

  // تحويل من JSON إلى ReviewModel
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  // تحويل من ReviewModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  // نسخ الكائن مع تعديل بعض الخصائص
  ReviewModel copyWith({
    UserModel? user,
    double? rating,
    String? comment,
    DateTime? date,
  }) {
    return ReviewModel(
      user: user ?? this.user,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}
