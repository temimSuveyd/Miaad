import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
          prefixIcon: Icon(prefixIcon, color: AppTheme.textSecondary, size: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.errorColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor2),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
    );
  }
}
