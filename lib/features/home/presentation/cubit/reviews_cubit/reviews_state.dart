import 'package:equatable/equatable.dart';
import '../../../data/models/review_model.dart';

// حالات التقييمات
abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

// حالة التحميل
class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

// حالة النجاح - عرض التقييمات
class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;
  final bool canAddReview;

  const ReviewsLoaded({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.canAddReview,
  });

  @override
  List<Object?> get props => [
    reviews,
    averageRating,
    totalReviews,
    ratingDistribution,
    canAddReview,
  ];

  ReviewsLoaded copyWith({
    List<ReviewModel>? reviews,
    double? averageRating,
    int? totalReviews,
    Map<String, int>? ratingDistribution,
    bool? canAddReview,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
      canAddReview: canAddReview ?? this.canAddReview,
    );
  }
}

// حالة إضافة تقييم
class ReviewsAdding extends ReviewsState {
  const ReviewsAdding();
}

// حالة نجاح إضافة التقييم
class ReviewAdded extends ReviewsState {
  final ReviewModel review;

  const ReviewAdded(this.review);

  @override
  List<Object?> get props => [review];
}

// حالة الخطأ
class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
