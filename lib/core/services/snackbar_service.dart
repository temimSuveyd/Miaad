import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../theme/app_theme.dart';

enum MessageType { success, failure, warning, help }

class SnackbarService {
  static void showMessage({
    required BuildContext context,
    required String title,
    required String message,
    MessageType messageType = MessageType.success,
    bool useMaterialBanner = false,
  }) {
    final contentType = _getContentType(messageType);

    if (useMaterialBanner) {
      _showMaterialBanner(
        context: context,
        title: title,
        message: message,
        contentType: contentType,
      );
    } else {
      _showSnackBar(
        context: context,
        title: title,
        message: message,
        contentType: contentType,
      );
    }
  }

  static void _showMaterialBanner({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        inMaterialBanner: true,
        color: _getColorForType(contentType),
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);

    // Auto hide after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  static void _showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        color: _getColorForType(contentType),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static ContentType _getContentType(MessageType messageType) {
    switch (messageType) {
      case MessageType.success:
        return ContentType.success;
      case MessageType.failure:
        return ContentType.failure;
      case MessageType.warning:
        return ContentType.warning;
      case MessageType.help:
        return ContentType.help;
    }
  }

  static Color _getColorForType(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return AppTheme.primaryColor2;
      case ContentType.failure:
        return const Color(0xFFF44336);
      case ContentType.warning:
        return const Color(0xFFFF9800);
      case ContentType.help:
        return AppTheme.accentColor;
      default:
        return AppTheme.primaryColor2;
    }
  }

  // Convenience methods for common message types
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    bool useMaterialBanner = false,
  }) {
    showMessage(
      context: context,
      title: title,
      message: message,
      messageType: MessageType.success,
      useMaterialBanner: useMaterialBanner,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    bool useMaterialBanner = false,
  }) {
    showMessage(
      context: context,
      title: title,
      message: message,
      messageType: MessageType.failure,
      useMaterialBanner: useMaterialBanner,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    bool useMaterialBanner = false,
  }) {
    showMessage(
      context: context,
      title: title,
      message: message,
      messageType: MessageType.warning,
      useMaterialBanner: useMaterialBanner,
    );
  }

  static void showHelp({
    required BuildContext context,
    required String title,
    required String message,
    bool useMaterialBanner = false,
  }) {
    showMessage(
      context: context,
      title: title,
      message: message,
      messageType: MessageType.help,
      useMaterialBanner: useMaterialBanner,
    );
  }
}
