import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';

class LocationHeaderWidget extends StatelessWidget {
  const LocationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الموقع',
                style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Iconsax.location5,
                    size: 24,
                    color: AppTheme.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'الرياض، السعودية',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppTheme.textPrimary,
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification5,
                  color: AppTheme.textPrimary.withOpacity(0.9),
                  size: 24,
                ),
              ),

              /// TODO eğer notifaction varsa nokta çoksın yok nokta çıkmasın
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
