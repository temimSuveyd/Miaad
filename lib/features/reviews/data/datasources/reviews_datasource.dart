import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/supabase_helper.dart';
import '../model/review_model.dart';

// مصدر بيانات التقييمات
abstract class ReviewsDatasource {
  // إنشاء تقييم جديد
  Future<ReviewModel> createReview(ReviewModel review);

  // الحصول على تقييم بواسطة المعرف
  Future<ReviewModel> getReviewById(String id);

  // الحصول على تقييمات الطبيب
  Future<List<ReviewModel>> getDoctorReviews(String doctorId);

  // الحصول على تقييمات الطبيب بشكل real-time
  Stream<List<ReviewModel>> getDoctorReviewsStream(String doctorId);

  // الحصول على تقييمات المستخدم
  Future<List<ReviewModel>> getUserReviews(String userId);

  // تحديث تقييم
  Future<ReviewModel> updateReview(ReviewModel review);

  // حذف تقييم
  Future<void> deleteReview(String id);

  // التحقق من وجود تقييم للمستخدم للطبيب
  Future<bool> hasUserReviewedDoctor(String userId, String doctorId);

  // الحصول على إحصائيات التقييمات للطبيب
  Future<Map<String, dynamic>> getDoctorReviewStats(String doctorId);
}

class ReviewsDatasourceImpl implements ReviewsDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  static const String tableName = 'reviews';
  static const String viewTable = 'user_reviews';

  @override
  Future<ReviewModel> createReview(ReviewModel review) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .insert(review.toJson())
          .select()
          .single();
      return ReviewModel.fromJson(json: response,isViewTaple: false );
    });
  }

  @override
  Future<ReviewModel> getReviewById(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('review_id', id)
          .single();

      return ReviewModel.fromJson(json: response,isViewTaple: true);
    });
  }

  @override
  Future<List<ReviewModel>> getDoctorReviews(String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('doctor_id', doctorId)
          .order('review_created_at', ascending: false);

      return (response as List)
          .map((json) => ReviewModel.fromJson(json: json,isViewTaple: true))
          .toList();
    });
  }

  @override
  Stream<List<ReviewModel>> getDoctorReviewsStream(String doctorId) {
    final controller = StreamController<List<ReviewModel>>.broadcast();

    // تحميل البيانات الأولية - Load initial data
    _loadInitialReviewData(doctorId, controller);

    // إنشاء قناة للاستماع للتغييرات - Create channel to listen for changes
    final channel = client
        .channel('reviews_$doctorId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: tableName, // استخدام TABLE وليس VIEW - Use TABLE not VIEW
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'doctor_id',
            value: doctorId,
          ),
          callback: (payload) {
            // إعادة تحميل البيانات عند حدوث تغيير - Reload data on change
            _loadInitialReviewData(doctorId, controller);
          },
        )
        .subscribe(); // ✅ تفعيل الاشتراك - Activate subscription

    // إلغاء الاشتراك عند إغلاق الـ stream - Cancel subscription when stream closes
    controller.onCancel = () {
      client.removeChannel(channel);
    };

    return controller.stream;
  }

  Future<void> _loadInitialReviewData(
    String doctorId,
    StreamController<List<ReviewModel>> controller,
  ) async {
    try {
      // جلب البيانات من الـ VIEW - Fetch data from VIEW
      final data = await client
          .from(viewTable)
          .select()
          .eq('doctor_id', doctorId)
          .order('review_created_at', ascending: false);
      // تحويل البيانات إلى نماذج - Convert data to models
      final reviews = (data as List)
          .map((json) => ReviewModel.fromJson(json: json,isViewTaple: true))
          .toList();

      // إضافة البيانات إلى الـ stream - Add data to stream
      if (!controller.isClosed) {
        controller.add(reviews);
      }
    } catch (e) {
      // إضافة الخطأ إلى الـ stream - Add error to stream
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  @override
  Future<List<ReviewModel>> getUserReviews(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('user_id', userId)
          .order('review_created_at', ascending: false);

      return (response as List)
          .map((json) => ReviewModel.fromJson(json: json,isViewTaple: true))
          .toList();
    });
  }

  @override
  Future<ReviewModel> updateReview(ReviewModel review) async {
    log(review.toString());
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .update(review.toJson())
          .eq('id', review.reviewId!)
          .select()
          .single();

      return ReviewModel.fromJson(json: response,isViewTaple: false);
    });
  }

  @override
  Future<void> deleteReview(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      await client.from(tableName).delete().eq('id', id);
    });
  }

  @override
  Future<bool> hasUserReviewedDoctor(String userId, String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('doctor_id', doctorId)
          .maybeSingle();

      return response != null;
    });
  }

  @override
  Future<Map<String, dynamic>> getDoctorReviewStats(String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select('rating')
          .eq('doctor_id', doctorId);

      final reviews = response as List;

      if (reviews.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalReviews': 0,
          'ratingDistribution': {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0},
        };
      }

      final ratings = reviews
          .map((r) => (r['rating'] as num).toDouble())
          .toList();
      final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

      // حساب توزيع التقييمات - Calculate rating distribution
      final ratingDistribution = <String, int>{
        '5': 0,
        '4': 0,
        '3': 0,
        '2': 0,
        '1': 0,
      };

      for (final rating in ratings) {
        final roundedRating = rating.round().toString();
        ratingDistribution[roundedRating] =
            (ratingDistribution[roundedRating] ?? 0) + 1;
      }

      return {
        'averageRating': double.parse(averageRating.toStringAsFixed(1)),
        'totalReviews': reviews.length,
        'ratingDistribution': ratingDistribution,
      };
    });
  }
}
