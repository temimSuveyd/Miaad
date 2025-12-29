import 'package:doctorbooking/features/home/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'review_card_widget.dart';

class ReviewsTabWidget extends StatelessWidget {
  final List<ReviewModel> reviews;

  const ReviewsTabWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewCardWidget(reviewModel: review);
      },
    );
  }
}
