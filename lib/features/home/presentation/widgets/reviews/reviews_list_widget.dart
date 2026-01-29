import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../reviews/data/model/review_model.dart';
import 'review_item.dart';

class ReviewsListWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  final String doctorId;
  final Function(ReviewModel) onEdit;
  final Function(String) onDelete;

  const ReviewsListWidget({
    super.key,
    required this.reviews,
    required this.doctorId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      sliver: SliverList.separated(
        itemCount: reviews.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppTheme.spacing16),
        itemBuilder: (context, index) {
          return ReviewItem(
            review: reviews[index],
            onEdit: onEdit,
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}
