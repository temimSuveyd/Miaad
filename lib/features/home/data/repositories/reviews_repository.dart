import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/reviews_datasource.dart';
import '../models/review_model.dart';

// مستودع التقييمات - إدارة العمليات مع معالجة الأخطاء
class ReviewsRepository {
  final ReviewsDatasource datasource;

  ReviewsRepository({required this.datasource});

  // إنشاء تقييم جديد
  Future<Either<Failure, ReviewModel>> createReview(ReviewModel review) async {
    try {
      final result = await datasource.createReview(review);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على تقييم بواسطة المعرف
  Future<Either<Failure, ReviewModel>> getReviewById(String id) async {
    try {
      final result = await datasource.getReviewById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على تقييمات الطبيب
  Future<Either<Failure, List<ReviewModel>>> getDoctorReviews(
    String doctorId,
  ) async {
    try {
      final result = await datasource.getDoctorReviews(doctorId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على تقييمات الطبيب بشكل real-time
  Stream<Either<Failure, List<ReviewModel>>> getDoctorReviewsStream(
    String doctorId,
  ) {
    try {
      return datasource
          .getDoctorReviewsStream(doctorId)
          .map((reviews) => Right<Failure, List<ReviewModel>>(reviews))
          .handleError((error) {
            return Left<Failure, List<ReviewModel>>(
              ServerFailure('خطأ في الاتصال: $error'),
            );
          });
    } catch (e) {
      return Stream.value(
        Left<Failure, List<ReviewModel>>(ServerFailure('خطأ في الاتصال: $e')),
      );
    }
  }

  // الحصول على تقييمات المستخدم
  Future<Either<Failure, List<ReviewModel>>> getUserReviews(
    String userId,
  ) async {
    try {
      final result = await datasource.getUserReviews(userId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // تحديث تقييم
  Future<Either<Failure, ReviewModel>> updateReview(ReviewModel review) async {
    try {
      final result = await datasource.updateReview(review);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // حذف تقييم
  Future<Either<Failure, void>> deleteReview(String id) async {
    try {
      await datasource.deleteReview(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // التحقق من وجود تقييم للمستخدم للطبيب
  Future<Either<Failure, bool>> hasUserReviewedDoctor(
    String userId,
    String doctorId,
  ) async {
    try {
      final result = await datasource.hasUserReviewedDoctor(userId, doctorId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على إحصائيات التقييمات للطبيب
  Future<Either<Failure, Map<String, dynamic>>> getDoctorReviewStats(
    String doctorId,
  ) async {
    try {
      final result = await datasource.getDoctorReviewStats(doctorId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }
}
