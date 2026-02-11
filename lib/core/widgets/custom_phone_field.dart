import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_size/uni_size.dart';
import '../theme/app_theme.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'رقم الهاتف',
    this.hintText = 'أدخل رقم هاتفك',
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  @override
  void initState() {
    super.initState();
    // Set default prefix if empty
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '963';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12), // 963 + 9 digits
        _PhoneFormatter(),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Syrian Flag (text-based)
              Container(
                width: 24.dp,
                height: 16.dp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.dp),
                  color: Colors.red,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2.dp),
                            topRight: Radius.circular(2.dp),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            width: 12.dp,
                            height: 4.dp,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2.dp),
                            bottomRight: Radius.circular(2.dp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
              // Country Code
              Text(
                '+963',
                style: AppTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: BorderSide(color: AppTheme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.dp,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: BorderSide(color: AppTheme.errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: 16.dp,
        ),
        hintStyle: AppTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondary,
        ),
        labelStyle: AppTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      validator: (value) {
        // Check if validator is provided
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        
        // Default validation
        if (value == null || value.trim().isEmpty) {
          return 'الرجاء إدخال رقم الهاتف';
        }
        
        // Remove the prefix for validation
        String phoneNumber = value.replaceAll('963', '');
        
        if (phoneNumber.length != 9) {
          return 'رقم الهاتف يجب أن يكون 9 أرقام بعد الرمز';
        }
        
        return null;
      },
      style: AppTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    
    // Ensure it starts with 963
    if (!text.startsWith('963')) {
      text = '963$text';
    }
    
    // Remove any non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 12 characters (963 + 9 digits)
    if (text.length > 12) {
      text = text.substring(0, 12);
    }
    
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
