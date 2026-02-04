import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:alert_info/alert_info.dart';

class SnackbarService {
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    int duration = 3,
  }) {
    AlertInfo.show(
      text: message,
      // action: message,
      context: context,
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
      icon: Icons.check_circle,
      duration: duration,
      typeInfo: TypeInfo.success,
      padding: 30,
      position: MessagePosition.bottom,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    int duration = 3,
  }) {
    AlertInfo.show(
      text: message,
      // action: message,
      context: context,
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
      icon: Icons.check_circle,
      duration: duration,
      typeInfo: TypeInfo.error,
      padding: 30,
      position: MessagePosition.bottom,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AlertInfo.show(
      text: message,
      // action: message,
      context: context,
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
      icon: Icons.warning,
      duration: duration.inSeconds,
      typeInfo: TypeInfo.warning,
      padding: 30,
      position: MessagePosition.bottom,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AlertInfo.show(
      text: message,
      // action: message,
      context: context,
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
      icon: Icons.info,
      duration: duration.inSeconds,
      typeInfo: TypeInfo.info,
      padding: 30,
      position: MessagePosition.bottom,
    );
  }

  // Generic method for custom alerts
  static void showCustom({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int duration,
  }) {
    AlertInfo.show(
      text: title,
      context: context,
      backgroundColor: AppTheme.primaryColor,
      textColor: AppTheme.backgroundColor,
      icon: icon,
      duration: duration,
      padding: 30,
      position: MessagePosition.bottom,
    );
  }
}
