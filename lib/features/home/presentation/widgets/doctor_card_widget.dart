import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String price;
  final String imageUrl;
  final Color backgroundColor;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const DoctorCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: backgroundColor,
                    child: const Icon(Icons.person, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  specialty,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFFB800),
                      size: 16,
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      '$rating',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      '($reviews Reviews)',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.primaryColor : AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              Text(
                price,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}