import 'package:doctorbooking/features/home/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({super.key, required this.reviewModel});
  final ReviewModel reviewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: reviewModel.user.imageUrl != null
                    ? NetworkImage(reviewModel.user.imageUrl!)
                    : null,
                backgroundColor: Colors.grey[300],
                child: reviewModel.user.imageUrl == null
                    ? Text(
                        reviewModel.user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewModel.user.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Row(
                      children: [
                        Text(
                          reviewModel.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: 5),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Iconsax.star1,
                              size: 16,
                              color: index < reviewModel.rating.round()
                                  ? const Color(0xFFFFB800)
                                  : Colors.grey[300],
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      DateFormat('dd MMM yyyy').format(reviewModel.date),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            reviewModel.comment,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
