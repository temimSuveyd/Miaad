import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../cubit/reviews_cubit/reviews_cubit.dart';
import '../../cubit/reviews_cubit/reviews_state.dart';
import 'add_review_dialog.dart';

// بطاقة إضافة تقييم مميزة
class AddReviewCard extends StatelessWidget {
  final String doctorId;
  final String doctorName;

  const AddReviewCard({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {

        // إذا لم يكن بإمكان المستخدم إضافة تقييم، إظهار رسالة تحفيزية
        if (state is ReviewsLoaded && !state.hasCompletedAppointment) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // أيقونة المعلومات
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),

                const SizedBox(width: AppTheme.spacing16),

                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'احجز موعداً لتتمكن من التقييم',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        'يمكنك إضافة تقييم بعد إكمال موعد مع $doctorName',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.orange.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }


        // حالة الخطأ
        if (state is ReviewsError) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: AppTheme.errorColor),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Text(
                    'خطأ في تحميل معلومات التقييم',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // لا تظهر شيئاً في الحالات الأخرى
        return const SizedBox.shrink();
      },
    );
  }
}
