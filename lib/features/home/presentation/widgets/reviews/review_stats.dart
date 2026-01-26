import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ويدجت إحصائيات التقييمات
class ReviewStats extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;

  const ReviewStats({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          // متوسط التقييم
          _buildAverageRating(),
          const SizedBox(width: AppTheme.spacing24),

          // توزيع النجوم
          Expanded(child: _buildRatingDistribution()),
        ],
      ),
    );
  }

  Widget _buildAverageRating() {
    return Column(
      children: [
        // الرقم
        Text(
          averageRating.toStringAsFixed(1),
          style: AppTheme.heading1.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        // النجوم
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < averageRating.floor()
                  ? Icons.star
                  : index < averageRating
                  ? Icons.star_half
                  : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),

        const SizedBox(height: 4),

        // عدد التقييمات
        Text(
          '$totalReviews değerlendirme',
          style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRatingDistribution() {
    final maxCount = ratingDistribution.values.isNotEmpty
        ? ratingDistribution.values.reduce((a, b) => a > b ? a : b)
        : 1;

    return Column(
      children: [5, 4, 3, 2, 1].map((rating) {
        final count = ratingDistribution[rating.toString()] ?? 0;
        final percentage = maxCount > 0 ? count / maxCount : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              // رقم النجمة
              Text(
                '$rating',
                style: AppTheme.caption.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),

              // النجمة
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 8),

              // شريط التقدم
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // العدد
              SizedBox(
                width: 20,
                child: Text(
                  '$count',
                  style: AppTheme.caption.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
