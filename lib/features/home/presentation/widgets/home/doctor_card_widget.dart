import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';

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
    required this.showFavorite,
    required this.doctorModel,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: AppTheme.spacing12.dp),
          padding: EdgeInsets.all(AppTheme.spacing8.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge.dp),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 80.dp,
                height: 80.dp,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
                  child: Image.network(
                    doctorModel.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.dividerColor,
                        child: Icon(Icons.person, size: 40.dp),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacing12.dp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          doctorModel.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacing4.dp),
                    Text(
                      doctorModel.specialty,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing8.dp),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFB800), size: 16.dp),
                        SizedBox(width: AppTheme.spacing4.dp),
                        Text(
                          '${doctorModel.rating}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          doctorModel.price,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
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
