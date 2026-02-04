import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/snackbar_service.dart';
import '../../../../../core/widgets/dialogs/base_dialog.dart';
import '../../../../reviews/presentation/cubit/reviews_cubit.dart';
import '../../../../reviews/presentation/cubit/reviews_state.dart';
import 'review_item.dart';
import 'review_stats.dart';
import 'add_review_dialog.dart';
import 'review_shimmer_widget.dart';

// قسم التقييمات الرئيسي
class ReviewsSection extends StatelessWidget {
  final String doctorId;

  const ReviewsSection({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewAdded) {
          SnackbarService.showSuccess(
            context: context,
            title: 'نجح',
            message: 'تم إضافة التقييم بنجاح',
          );
        } else if (state is ReviewsError) {
          SnackbarService.showError(
            context: context,
            title: 'خطأ',
            message: state.message,
          );
        }
      },
      child: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان وزر إضافة التقييم
              _buildHeader(context, state),
              const SizedBox(height: AppTheme.spacing16),

              // المحتوى
              _buildContent(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ReviewsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('التقييمات', style: AppTheme.sectionTitle),

        // Review ekleme butonu - daha geniş koşullarda göster
        if (state is ReviewsLoaded) ...[
          if (state.canAddReview && state.hasCompletedAppointment)
            // Kullanıcı review ekleyebilir
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: () => _showAddReviewDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('إضافة تقييم'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  elevation: 0,
                ),
              ),
            )
          else if (!state.hasCompletedAppointment)
            // Kullanıcı henüz appointment tamamlamamış
            OutlinedButton.icon(
              onPressed: () => _showAppointmentRequiredDialog(context),
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text('إضافة تقييم'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: BorderSide(color: Colors.orange.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
              ),
            )
          else
            // Kullanıcı zaten review yapmış - buton gösterme
            const SizedBox.shrink(),
        ],
      ],
    );
  }

  Widget _buildContent(BuildContext context, ReviewsState state) {
    return switch (state) {
      ReviewsLoading() => const ReviewShimmerWidget(),
      ReviewsError() => _buildErrorWidget(context, state.message),
      ReviewsLoaded() => _buildLoadedContent(context, state),
      _ => _buildEmptyWidget(),
    };
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing16),
            ElevatedButton(
              onPressed: () {
                context.read<ReviewsCubit>().loadDoctorReviews(doctorId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, ReviewsLoaded state) {
    return Column(
      children: [
        // الإحصائيات
        ReviewStats(
          averageRating: state.averageRating,
          totalReviews: state.totalReviews,
          ratingDistribution: state.ratingDistribution,
        ),
        const SizedBox(height: AppTheme.spacing24),

        // قائمة التقييمات
        if (state.reviews.isEmpty)
          _buildEmptyReviewsWidget(
            context,
            state.canAddReview,
            state.hasCompletedAppointment,
          )
        else
          _buildReviewsList(context, state.reviews),
      ],
    );
  }

  Widget _buildEmptyReviewsWidget(
    BuildContext context,
    bool canAddReview,
    bool hasCompletedAppointment,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text('لا توجد تقييمات بعد', style: AppTheme.bodyMedium),
            const SizedBox(height: AppTheme.spacing16),

            if (!hasCompletedAppointment) ...[
              // رسالة عدم وجود موعد مكتمل
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 24),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'لإضافة تقييم، يجب أن يكون لديك موعد مكتمل مع هذا الطبيب',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else if (canAddReview) ...[
              // زر إضافة التقييم
              ElevatedButton(
                onPressed: () => _showAddReviewDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('كن أول من يقيم'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, List reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppTheme.spacing16),
      itemBuilder: (context, index) {
        return ReviewItem(
          review: reviews[index],
          onEdit: (review) => _showEditReviewDialog(context, review),
          onDelete: (reviewId) => _showDeleteConfirmation(context, reviewId),
        );
      },
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing32),
        child: Text('لا توجد بيانات'),
      ),
    );
  }

  void _showAppointmentRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BaseDialog(
        icon: DialogIcon(icon: Icons.info_outline, color: Colors.orange),
        title: 'موعد مطلوب للتقييم',
        subtitle:
            'يجب أن يكون لديك موعد مكتمل مع هذا الطبيب لتتمكن من إضافة تقييم',
        content: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'فهمت',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // يمكن إضافة navigation إلى صفحة حجز المواعيد هنا
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('احجز موعد'),
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddReviewDialog(
        doctorId: doctorId,
        onSubmit: (rating, comment) {
          // Parent context'i kullan, dialog context'ini değil
          context.read<ReviewsCubit>().addReview(
            doctorId: doctorId,
            rating: rating,
            comment: comment,
          );
        },
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, review) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddReviewDialog(
        doctorId: doctorId,
        initialRating: review.rating,
        initialComment: review.comment,
        isEditing: true,
        onSubmit: (rating, comment) {
          // Parent context'i kullan, dialog context'ini değil
          context.read<ReviewsCubit>().updateReview(
            reviewId: review.reviewId!,
            rating: rating,
            comment: comment,
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (dialogContext) => BaseDialog(
        icon: DialogIcon(
          icon: Icons.delete_outline,
          color: AppTheme.errorColor,
        ),
        title: 'حذف التقييم',
        subtitle: 'هل أنت متأكد من حذف هذا التقييم؟',
        content: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Parent context'i kullan, dialog context'ini değil
              context.read<ReviewsCubit>().deleteReview(reviewId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
