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
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: reviewModel.user.imageUrl != null
                    ? NetworkImage(reviewModel.user.imageUrl!)
                    : null,
                backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                child: reviewModel.user.imageUrl == null
                    ? Text(
                        reviewModel.user.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewModel.user.name,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Row(
                      children: [
                        Text(
                          reviewModel.rating.toStringAsFixed(1),
                          style: AppTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing4),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Iconsax.star1,
                              size: 14,
                              color: index < reviewModel.rating.round()
                                  ? const Color(0xFFFFB800)
                                  : AppTheme.dividerColor,
                            );
                          }),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Text(
                          DateFormat('dd MMM yyyy').format(reviewModel.date),
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            reviewModel.comment,
            style: AppTheme.bodyMedium.copyWith(height: 1.6, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
