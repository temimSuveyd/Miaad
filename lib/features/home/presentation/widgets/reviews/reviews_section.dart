import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../cubit/reviews_cubit/reviews_cubit.dart';
import '../../cubit/reviews_cubit/reviews_state.dart';
import 'review_item.dart';
import 'review_stats.dart';
import 'add_review_dialog.dart';

class ReviewsSection extends StatelessWidget {
  final String doctorId;

  const ReviewsSection({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve değerlendirme ekle butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Değerlendirmeler', style: AppTheme.sectionTitle),
                if (state is ReviewsLoaded && state.canAddReview)
                  TextButton.icon(
                    onPressed: () => _showAddReviewDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Değerlendirme Yap'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),

            // İçerik
            if (state is ReviewsLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacing32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is ReviewsError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        state.message,
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ReviewsCubit>().loadDoctorReviews(
                            doctorId,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state is ReviewsLoaded)
              Column(
                children: [
                  // İstatistikler
                  ReviewStats(
                    averageRating: state.averageRating,
                    totalReviews: state.totalReviews,
                    ratingDistribution: state.ratingDistribution,
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Değerlendirmeler listesi
                  if (state.reviews.isEmpty)
                    Center(
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
                            Text(
                              'Henüz değerlendirme yapılmamış',
                              style: AppTheme.bodyMedium,
                            ),
                            if (state.canAddReview) ...[
                              const SizedBox(height: AppTheme.spacing16),
                              ElevatedButton(
                                onPressed: () => _showAddReviewDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('İlk Değerlendirmeyi Yap'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.reviews.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: AppTheme.spacing32),
                      itemBuilder: (context, index) {
                        return ReviewItem(
                          review: state.reviews[index],
                          onEdit: (review) =>
                              _showEditReviewDialog(context, review),
                          onDelete: (reviewId) =>
                              _showDeleteConfirmation(context, reviewId),
                        );
                      },
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        doctorId: doctorId,
        onSubmit: (rating, comment) {
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
      builder: (context) => AddReviewDialog(
        doctorId: doctorId,
        initialRating: review.rating,
        initialComment: review.comment,
        isEditing: true,
        onSubmit: (rating, comment) {
          context.read<ReviewsCubit>().updateReview(
            reviewId: review.id!,
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
      builder: (context) => AlertDialog(
        title: const Text('Değerlendirmeyi Sil'),
        content: const Text(
          'Bu değerlendirmeyi silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewsCubit>().deleteReview(reviewId);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
