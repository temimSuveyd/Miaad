import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'review_card_widget.dart';

class ReviewsTabWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsTabWidget({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewCardWidget(
          userName: review['userName'] ?? '',
          userImage: review['userImage'] ?? '',
          rating: (review['rating'] ?? 0.0).toDouble(),
          reviewText: review['reviewText'] ?? '',
          date: review['date'] ?? '',
        );
      },
    );
  }
}