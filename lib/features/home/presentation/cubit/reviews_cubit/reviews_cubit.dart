import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/mock/mock_doctor_data.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/reviews_repository.dart';
import 'reviews_state.dart';

// Cubit لإدارة حالة التقييمات
class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository repository;
  StreamSubscription? _reviewsSubscription;

  ReviewsCubit({required this.repository}) : super(const ReviewsInitial());

  String? _currentDoctorId;
  // Use mock user id for testing
  final String _currentUserId = MockDoctorData.userId;

  // تحميل تقييمات الطبيب مع الاستماع للتحديثات المباشرة
  Future<void> loadDoctorReviews(String doctorId) async {
    try {
      _currentDoctorId = doctorId;

      emit(const ReviewsLoading());

      // إلغاء الاشتراك السابق إن وجد
      await _reviewsSubscription?.cancel();

      // الاستماع للتحديثات المباشرة
      _reviewsSubscription = repository.getDoctorReviewsStream(doctorId).listen(
        (result) async {
          result.fold((failure) => emit(ReviewsError(failure.message)), (
            reviews,
          ) async {
            // الحصول على إحصائيات التقييمات
            final statsResult = await repository.getDoctorReviewStats(doctorId);

            statsResult.fold((failure) => emit(ReviewsError(failure.message)), (
              stats,
            ) async {
              // التحقق من إمكانية إضافة تقييم
              bool canAddReview = false;
              final hasReviewedResult = await repository.hasUserReviewedDoctor(
                _currentUserId,
                doctorId,
              );

              hasReviewedResult.fold(
                (failure) => canAddReview = false,
                (hasReviewed) => canAddReview = !hasReviewed,
              );

              emit(
                ReviewsLoaded(
                  reviews: reviews,
                  averageRating: stats['averageRating'] ?? 0.0,
                  totalReviews: stats['totalReviews'] ?? 0,
                  ratingDistribution: Map<String, int>.from(
                    stats['ratingDistribution'] ?? {},
                  ),
                  canAddReview: canAddReview,
                ),
              );
            });
          });
        },
      );
    } catch (e) {
      emit(ReviewsError('خطأ في تحميل التقييمات: $e'));
    }
  }

  // إضافة تقييم جديد
  Future<void> addReview({
    required String doctorId,
    required double rating,
    required String comment,
  }) async {
    try {
      emit(const ReviewsAdding());

      final review = ReviewModel(
        userId: _currentUserId,
        doctorId: doctorId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      final result = await repository.createReview(review);

      result.fold((failure) => emit(ReviewsError(failure.message)), (
        createdReview,
      ) {
        emit(ReviewAdded(createdReview));
        // إعادة تحميل التقييمات لتحديث القائمة
        if (_currentDoctorId != null) {
          loadDoctorReviews(_currentDoctorId!);
        }
      });
    } catch (e) {
      emit(ReviewsError('خطأ في إضافة التقييم: $e'));
    }
  }

  // تحديث تقييم موجود
  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    try {
      emit(const ReviewsAdding());

      // الحصول على التقييم الحالي
      final currentReviewResult = await repository.getReviewById(reviewId);

      await currentReviewResult.fold(
        (failure) async => emit(ReviewsError(failure.message)),
        (currentReview) async {
          final updatedReview = currentReview.copyWith(
            rating: rating,
            comment: comment,
          );

          final result = await repository.updateReview(updatedReview);

          result.fold((failure) => emit(ReviewsError(failure.message)), (
            review,
          ) {
            emit(ReviewAdded(review));
            // إعادة تحميل التقييمات لتحديث القائمة
            if (_currentDoctorId != null) {
              loadDoctorReviews(_currentDoctorId!);
            }
          });
        },
      );
    } catch (e) {
      emit(ReviewsError('خطأ في تحديث التقييم: $e'));
    }
  }

  // حذف تقييم
  Future<void> deleteReview(String reviewId) async {
    try {
      emit(const ReviewsAdding());

      final result = await repository.deleteReview(reviewId);

      result.fold((failure) => emit(ReviewsError(failure.message)), (_) {
        // إعادة تحميل التقييمات لتحديث القائمة
        if (_currentDoctorId != null) {
          loadDoctorReviews(_currentDoctorId!);
        }
      });
    } catch (e) {
      emit(ReviewsError('خطأ في حذف التقييم: $e'));
    }
  }

  // التحقق من إمكانية إضافة تقييم
  Future<bool> canUserAddReview(String doctorId) async {
    final result = await repository.hasUserReviewedDoctor(
      _currentUserId,
      doctorId,
    );

    return result.fold((failure) => false, (hasReviewed) => !hasReviewed);
  }

  @override
  Future<void> close() {
    _reviewsSubscription?.cancel();
    return super.close();
  }
}
