import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/mock/mock_doctor_data.dart';
import '../../../data/models/review_model.dart';

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
    // Use mock user id for testing
    final currentUserId = MockDoctorData.userId;
    final isOwner = currentUserId == review.userId;

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
          // Üst kısım - Kullanıcı bilgileri ve yıldızlar
          Row(
            children: [
              // Kullanıcı avatarı
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage: review.userImageUrl != null
                    ? NetworkImage(review.userImageUrl!)
                    : null,
                child: review.userImageUrl == null
                    ? Text(
                        (review.userName ?? 'U').substring(0, 1).toUpperCase(),
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppTheme.spacing12),

              // Kullanıcı adı ve tarih
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Anonim Kullanıcı',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatReviewDate(review.createdAt),
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),

              // Yıldızlar
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

              // Menü butonu (sadece kendi yorumu için)
              if (isOwner) ...[
                const SizedBox(width: AppTheme.spacing8),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call(review);
                    } else if (value == 'delete') {
                      onDelete?.call(review.id!);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 18,
                            color: AppTheme.errorColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sil',
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

          // Yorum metni
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
