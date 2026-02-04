import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../cubit/reviews_cubit.dart';
import '../cubit/reviews_state.dart';
import '../../../home/presentation/widgets/reviews/add_review_button_widget.dart';
import '../../../home/presentation/widgets/reviews/add_review_dialog.dart';
import '../../../home/presentation/widgets/reviews/review_stats.dart';
import '../../../home/presentation/widgets/reviews/reviews_empty_widget.dart';
import '../../../home/presentation/widgets/reviews/reviews_error_widget.dart';
import '../../../home/presentation/widgets/reviews/reviews_list_widget.dart';
import '../../../home/presentation/widgets/reviews/reviews_shimmer_widget.dart';

/// Reviews page for displaying and managing doctor reviews

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final doctorId = args['doctorId'] as String;

    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..loadDoctorReviews(doctorId),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: CustomAppBar(title: 'التقييمات', showleading: true),
        body: BlocConsumer<ReviewsCubit, ReviewsState>(
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
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const ReviewsShimmerWidget();
            }

            if (state is ReviewsError) {
              return ReviewsErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<ReviewsCubit>().loadDoctorReviews(doctorId),
              );
            }

            if (state is ReviewsLoaded) {
              return _buildLoadedContent(context, state, doctorId);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    ReviewsLoaded state,
    String doctorId,
  ) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing20)),

        // Rating Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: ReviewStats(
              averageRating: state.averageRating,
              totalReviews: state.totalReviews,
              ratingDistribution: state.ratingDistribution,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // Add Review Button - Only show if user hasn't reviewed yet
        if (state.canAddReview)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
              ),
              child: AddReviewButtonWidget(
                onPressed: () => _showAddReviewDialog(context, doctorId),
              ),
            ),
          ),

        if (state.canAddReview)
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),

        // Reviews Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Text(
              'جميع التقييمات (${state.totalReviews})',
              style: AppTheme.sectionTitle,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),

        // Reviews List or Empty State
        if (state.reviews.isEmpty)
          SliverToBoxAdapter(
            child: ReviewsEmptyWidget(
              canAddReview: state.canAddReview && state.hasCompletedAppointment,
              onAddReview: (state.canAddReview && state.hasCompletedAppointment)
                  ? () => _showAddReviewDialog(context, doctorId)
                  : null,
            ),
          )
        else
          ReviewsListWidget(
            reviews: state.reviews,
            doctorId: doctorId,
            onEdit: (review) =>
                _showEditReviewDialog(context, review, doctorId),
            onDelete: (reviewId) => _showDeleteConfirmation(context, reviewId),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
      ],
    );
  }

  void _showAddReviewDialog(BuildContext context, String doctorId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddReviewDialog(
        doctorId: doctorId,
        onSubmit: (rating, comment) {
          Navigator.pop(dialogContext);
          context.read<ReviewsCubit>().addReview(
            doctorId: doctorId,
            rating: rating,
            comment: comment,
          );
        },
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, review, String doctorId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddReviewDialog(
        doctorId: doctorId,
        initialRating: review.rating,
        initialComment: review.comment,
        isEditing: true,
        onSubmit: (rating, comment) {
          Navigator.pop(dialogContext);
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف التقييم'),
        content: const Text('هل أنت متأكد من حذف هذا التقييم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ReviewsCubit>().deleteReview(reviewId);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
