import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/dialogs/base_dialog.dart';

// دايلوج إضافة تقييم مخصص
class AddReviewDialog extends StatefulWidget {
  final String doctorId;
  final double? initialRating;
  final String? initialComment;
  final bool isEditing;
  final Function(double rating, String comment) onSubmit;

  const AddReviewDialog({
    super.key,
    required this.doctorId,
    this.initialRating,
    this.initialComment,
    this.isEditing = false,
    required this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  late double _rating;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5;
    _commentController = TextEditingController(
      text: widget.initialComment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      icon: DialogIcon(icon: Icons.rate_review, color: AppTheme.primaryColor),
      title: widget.isEditing ? 'تعديل التقييم' : 'إضافة تقييم',
      subtitle: 'شاركنا تجربتك مع الطبيب',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختيار النقاط
            Text(
              'تقييمك',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),

            // النجوم التفاعلية
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1.0;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = starValue;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      _rating >= starValue ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppTheme.spacing8),

            // نص التقييم
            Center(
              child: Text(
                _getRatingText(_rating),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),

            // حقل التعليق
            Text(
              'تعليقك',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'شاركنا تجربتك مع الطبيب...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  borderSide: const BorderSide(color: AppTheme.primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى كتابة تعليق';
                }
                if (value.trim().length < 10) {
                  return 'التعليق يجب أن يكون 10 أحرف على الأقل';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        // زر الإلغاء
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text('إلغاء', style: TextStyle(color: AppTheme.textSecondary)),
        ),

        // زر الإرسال
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(widget.isEditing ? 'تحديث' : 'إرسال'),
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    return switch (rating.toInt()) {
      1 => 'سيء جداً',
      2 => 'سيء',
      3 => 'متوسط',
      4 => 'جيد',
      5 => 'ممتاز',
      _ => 'ممتاز',
    };
  }

  void _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      widget.onSubmit(_rating, _commentController.text.trim());
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
