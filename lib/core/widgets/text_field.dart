import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
  });
  final String hintText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          fillColor: AppTheme.dividerColor,
          filled: true,
          prefixIcon: Icon(
            prefixIcon,
            color: AppTheme.textSecondary,
            size: 20.dp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.errorColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
          ),
        ),
      ),
    );
  }
}
