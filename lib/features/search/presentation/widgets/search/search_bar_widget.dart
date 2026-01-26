import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacing16.dp),
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.dp,
        vertical: AppTheme.spacing4.dp,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall.dp),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal,
            color: AppTheme.textSecondary,
            size: 20.dp,
          ),
          SizedBox(width: AppTheme.spacing12.dp),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن طبيب، تخصص، أو مستشفى...',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTheme.bodyMedium,
            ),
          ),
          // Show clear button when there's text
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppTheme.textSecondary,
                        size: 20.dp,
                      ),
                      onPressed: onClear,
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
