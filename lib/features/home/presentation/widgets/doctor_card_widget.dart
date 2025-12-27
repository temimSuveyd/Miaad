import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorCardWidget extends StatelessWidget {
  final bool isFavorite;
  final bool showFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final DoctorModel doctorModel;

  const DoctorCardWidget({
    super.key,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
    required this.showFavorite, required this.doctorModel,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Image.network(
                   doctorModel.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.dividerColor,
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
                    Row(
                      children: [
                        Text(
                         doctorModel. name,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        if (showFavorite)
                          GestureDetector(
                            onTap: onFavoriteTap,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? AppTheme.primaryColor
                                  : AppTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                    doctorModel.  specialty,
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
                          '${doctorModel.rating}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                         doctorModel.price,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
