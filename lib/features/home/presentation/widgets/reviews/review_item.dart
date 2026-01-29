import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/mock/mock_doctor_data.dart';
import '../../../../reviews/data/model/review_model.dart';

// ويدجت عنصر التقييم
class ReviewItem extends StatelessWidget {
  final ReviewModel review;
  final Function(ReviewModel)? onEdit;
  final Function(String)? onDelete;

  const ReviewItem({
    super.key,
    required this.review,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام معرف المستخدم المؤقت للاختبار
    final currentUserId = MockDoctorData.userId;
    final isOwner = review.isOwnedBy(currentUserId);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الجزء العلوي - معلومات المستخدم والنجوم
          Row(
            children: [
              // صورة المستخدم
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                backgroundImage: review.displayImageUrl.isNotEmpty
                    ? NetworkImage(review.displayImageUrl)
                    : null,
                child: review.displayImageUrl.isEmpty
                    ? Text(
                        review.displayName.substring(0, 1).toUpperCase(),
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppTheme.spacing12),

              // اسم المستخدم والتاريخ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.displayName,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.getRelativeTime(review.reviewCreatedAt),
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),

              // النجوم
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : index < review.rating
                        ? Icons.star_half
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),

              // زر القائمة (فقط للتقييم الخاص بالمستخدم)
              if (isOwner) ...[
                const SizedBox(width: AppTheme.spacing8),
                PopupMenuButton<String>(
                  color: AppTheme.cardBackground,
                  icon: Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call(review);
                    } else if (value == 'delete') {
                      onDelete?.call(review.reviewId!);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Iconsax.edit, size: 18),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_outlined,
                            size: 18,
                            color: AppTheme.errorColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'حذف',
                            style: TextStyle(color: AppTheme.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          const SizedBox(height: AppTheme.spacing12),

          // نص التعليق
          Text(
            review.comment,
            style: AppTheme.bodyMedium.copyWith(
              height: 1.5,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
