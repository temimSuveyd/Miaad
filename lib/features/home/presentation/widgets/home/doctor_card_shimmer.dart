import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/shimmer_widget.dart';

class DoctorCardShimmer extends StatelessWidget {
  const DoctorCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Container(
        margin: EdgeInsets.only(bottom: AppTheme.spacing12.dp),
        padding: EdgeInsets.all(AppTheme.spacing8.dp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
        ),
        child: Row(
          children: [
            // Doctor Image Shimmer
            ShimmerContainer(
              width: 80.dp,
              height: 80.dp,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
            ),
            SizedBox(width: AppTheme.spacing12.dp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Name Shimmer
                  ShimmerContainer(
                    width: double.infinity,
                    height: 16.dp,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: AppTheme.spacing8.dp),

                  // Specialty Shimmer
                  ShimmerContainer(
                    width: 200.dp,
                    height: 14.dp,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: AppTheme.spacing12.dp),

                  // Rating and Price Row
                  Row(
                    children: [
                      // Rating Shimmer
                      ShimmerContainer(
                        width: 60.dp,
                        height: 12.dp,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const Spacer(),
                      // Price Shimmer
                      ShimmerContainer(
                        width: 80.dp,
                        height: 12.dp,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Multiple shimmer cards for loading state
class DoctorCardsShimmerList extends StatelessWidget {
  final int itemCount;

  const DoctorCardsShimmerList({super.key, this.itemCount = 2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16.dp),
      child: Column(
        children: List.generate(
          4,
          (index) => const DoctorCardShimmer(),
        ),
      ),
    );
  }
}
