import 'package:flutter/material.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';

class EmailInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;

  const EmailInputWidget({
    super.key,
    required this.controller,
    this.validator,
    this.label = 'البريد الإلكتروني',
    this.hintText = 'example@email.com',
  });

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Overall RTL for Arabic UI
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.right, // Align text to right for Arabic
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
