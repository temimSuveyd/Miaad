import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

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
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Sol taraf - Ortalama puan
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: AppTheme.heading1.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating.floor()
                              ? Icons.star
                              : index < averageRating
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalReviews değerlendirme',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppTheme.spacing24),

              // Sağ taraf - Puan dağılımı
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    for (int i = 5; i >= 1; i--)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: _buildRatingBar(
                          i,
                          ratingDistribution['$i'] ?? 0,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int rating, int count) {
    final percentage = totalReviews > 0 ? count / totalReviews : 0.0;

    return Row(
      children: [
        // Yıldız sayısı
        Text(
          '$rating',
          style: AppTheme.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: AppTheme.spacing8),

        // Progress bar
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
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing8),

        // Sayı
        SizedBox(
          width: 20,
          child: Text(
            '$count',
            style: AppTheme.caption,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
