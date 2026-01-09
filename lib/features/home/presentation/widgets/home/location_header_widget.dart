import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';

class LocationHeaderWidget extends StatelessWidget {
  const LocationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الموقع',
              style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 4.dp),
            Row(
              children: [
                Icon(
                  Iconsax.location5,
                  size: 24.dp,
                  color: AppTheme.textPrimary,
                ),
                SizedBox(width: 4.dp),
                Text(
                  'الرياض، السعودية',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.dp),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.dp,
                  color: AppTheme.textPrimary,
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8.dp),
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.notification5,
                color: AppTheme.textPrimary.withValues(alpha: 0.9),
                size: 24.dp,
              ),
            ),

            /// TODO eğer notifaction varsa nokta çoksın yok nokta çıkmasın
            Positioned(
              right: 8.dp,
              top: 8.dp,
              child: Container(
                width: 8.dp,
                height: 8.dp,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
