import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/mock/mock_doctor_data.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/reviews_repository.dart';
import 'reviews_state.dart';

// كيوبت إدارة حالة التقييمات
class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository repository;
  StreamSubscription? _reviewsSubscription;

  ReviewsCubit({required this.repository}) : super(const ReviewsInitial());

  String? _currentDoctorId;
  // استخدام معرف المستخدم المؤقت للاختبار
  final String _currentUserId = MockDoctorData.userId;

  // تحميل تقييمات الطبيب مع الاستماع للتحديثات المباشرة
  Future<void> loadDoctorReviews(String doctorId) async {
    try {
      _currentDoctorId = doctorId;

      emit(const ReviewsLoading());

      // إلغاء الاشتراك السابق إن وجد
      await _reviewsSubscription?.cancel();

      // الاستماع للتحديثات المباشرة
      _reviewsSubscription = repository.getDoctorReviewsStream(doctorId).listen((
        result,
      ) async {
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

            // أولاً: التحقق من وجود موعد مكتمل
            final hasCompletedAppointmentResult = await repository
                .hasCompletedAppointmentWithDoctor(_currentUserId, doctorId);

            bool hasCompletedAppointment = false;
            hasCompletedAppointmentResult.fold(
              (failure) {
                print(
                  '❌ Error checking completed appointment: ${failure.message}',
                );
                hasCompletedAppointment = false;
              },
              (hasCompleted) {
                print('✅ Has completed appointment: $hasCompleted');
                print('👤 Current user ID: $_currentUserId');
                print('👨‍⚕️ Doctor ID: $doctorId');
                hasCompletedAppointment = hasCompleted;
              },
            );

            // 🚨 TEMPORARY: Force hasCompletedAppointment to true for testing
            hasCompletedAppointment = true;
            print('🧪 TESTING: Forced hasCompletedAppointment = true');

            // ثانياً: التحقق من عدم وجود تقييم سابق
            if (hasCompletedAppointment) {
              final hasReviewedResult = await repository.hasUserReviewedDoctor(
                _currentUserId,
                doctorId,
              );

              hasReviewedResult.fold(
                (failure) {
                  print('❌ Error checking existing review: ${failure.message}');
                  canAddReview = false;
                },
                (hasReviewed) {
                  print('📝 Has existing review: $hasReviewed');
                  canAddReview = !hasReviewed;
                  print('✨ Can add review: $canAddReview');
                },
              );
            } else {
              print('⚠️ No completed appointment found - cannot add review');
            }

            emit(
              ReviewsLoaded(
                reviews: reviews,
                averageRating: stats['averageRating'] ?? 0.0,
                totalReviews: stats['totalReviews'] ?? 0,
                ratingDistribution: Map<String, int>.from(
                  stats['ratingDistribution'] ?? {},
                ),
                canAddReview: canAddReview,
                hasCompletedAppointment: hasCompletedAppointment,
              ),
            );
          });
        });
      });
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

      // التحقق من وجود موعد مكتمل أولاً
      final hasCompletedAppointmentResult = await repository
          .hasCompletedAppointmentWithDoctor(_currentUserId, doctorId);

      final hasCompletedAppointment = hasCompletedAppointmentResult.fold(
        (failure) => false,
        (hasCompleted) => hasCompleted,
      );

      if (!hasCompletedAppointment) {
        emit(
          const ReviewsError(
            'يجب أن يكون لديك موعد مكتمل مع هذا الطبيب لتتمكن من إضافة تقييم',
          ),
        );
        return;
      }

      final review = ReviewModel(
        reviewCreatedAt: DateTime.now(),
        userId: _currentUserId,
        doctorId: doctorId,
        userFullName: MockDoctorData.userName,
        userEmail: MockDoctorData.userEmail,
        userPhone: MockDoctorData.userPhone,
        rating: rating,
        comment: comment,
      );

      final result = await repository.createReview(review);

      result.fold((failure) => emit(ReviewsError(failure.message)), (
        createdReview,
      ) {
        emit(ReviewAdded(createdReview));
        // إعادة تحميل التقييمات لتحديث القائمة
        loadDoctorReviews(doctorId);
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

      // الحصول على التقييم الحالي أولاً
      final currentReviewResult = await repository.getReviewById(reviewId);

      currentReviewResult.fold(
        (failure) => emit(ReviewsError(failure.message)),
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

  // الحصول على تقييمات المستخدم
  Future<void> loadUserReviews() async {
    try {
      emit(const ReviewsLoading());

      final result = await repository.getUserReviews(_currentUserId);

      result.fold(
        (failure) => emit(ReviewsError(failure.message)),
        (reviews) => emit(
          ReviewsLoaded(
            reviews: reviews,
            averageRating: 0.0,
            totalReviews: reviews.length,
            ratingDistribution: {},
            canAddReview: false,
          ),
        ),
      );
    } catch (e) {
      emit(ReviewsError('خطأ في تحميل تقييمات المستخدم: $e'));
    }
  }

  @override
  Future<void> close() {
    _reviewsSubscription?.cancel();
    return super.close();
  }
}
