import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/secure_storage_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Notification channels
  static const String _appointmentChannel = 'appointments';
  static const String _messageChannel = 'messages';
  static const String _promoChannel = 'promotions';
  static const String _healthChannel = 'health_tips';

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _notificationStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream => 
      _notificationStreamController.stream;

  // Initialize notification service
  Future<void> initialize() async {
    try {
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize notification channels
      await _initializeChannels();
      
      // Load notification settings
      await _loadNotificationSettings();
      
      print('Notification service initialized successfully');
    } catch (e) {
      print('Failed to initialize notification service: $e');
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    // This would integrate with flutter_local_notifications
    // For now, we'll store the permission state
    await SecureStorageService.saveNotificationsEnabled(true);
  }

  // Initialize notification channels
  Future<void> _initializeChannels() async {
    // Channel definitions would go here for flutter_local_notifications
    print('Notification channels initialized');
  }

  // Load notification settings from secure storage
  Future<void> _loadNotificationSettings() async {
    try {
      final notificationsEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final emailNotificationsEnabled = await SecureStorageService.getEmailNotificationsEnabled() ?? true;
      final pushNotificationsEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;

      // Broadcast loaded settings
      _notificationStreamController.add({
        'type': 'settings_loaded',
        'notifications_enabled': notificationsEnabled,
        'email_notifications_enabled': emailNotificationsEnabled,
        'push_notifications_enabled': pushNotificationsEnabled,
      });
    } catch (e) {
      print('Failed to load notification settings: $e');
    }
  }

  // Send appointment notification
  Future<void> sendAppointmentNotification({
    required String doctorName,
    required String appointmentTime,
    required String appointmentDate,
  }) async {
    try {
      final isEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final isPushEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;
      final isEmailEnabled = await SecureStorageService.getEmailNotificationsEnabled() ?? true;

      if (!isEnabled) return;

      final notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'تذكير بالموعد',
        'body': 'موعدك مع دكتور $doctorName في $appointmentTime بتاريخ $appointmentDate',
        'doctor_name': doctorName,
        'appointment_time': appointmentTime,
        'appointment_date': appointmentDate,
        'channel': _appointmentChannel,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      // Send push notification
      if (isPushEnabled) {
        await _sendPushNotification(notificationData);
      }

      // Send email notification
      if (isEmailEnabled) {
        await _sendEmailNotification(notificationData);
      }

      // Save to local storage for notification history
      await _saveNotificationToHistory(notificationData);

      // Broadcast to stream
      _notificationStreamController.add({
        'type': 'new_notification',
        'data': notificationData,
      });

      print('Appointment notification sent: $notificationData');
    } catch (e) {
      print('Failed to send appointment notification: $e');
    }
  }

  // Send message notification
  Future<void> sendMessageNotification({
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    try {
      final isEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final isPushEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;
      final isEmailEnabled = await SecureStorageService.getEmailNotificationsEnabled() ?? true;

      if (!isEnabled) return;

      final notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'رسالة جديدة من $senderName',
        'body': message,
        'sender_name': senderName,
        'sender_avatar': senderAvatar,
        'channel': _messageChannel,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      if (isPushEnabled) {
        await _sendPushNotification(notificationData);
      }

      if (isEmailEnabled) {
        await _sendEmailNotification(notificationData);
      }

      await _saveNotificationToHistory(notificationData);

      _notificationStreamController.add({
        'type': 'new_notification',
        'data': notificationData,
      });

      print('Message notification sent: $notificationData');
    } catch (e) {
      print('Failed to send message notification: $e');
    }
  }

  // Send promotional notification
  Future<void> sendPromotionalNotification({
    required String title,
    required String description,
    required String discountCode,
  }) async {
    try {
      final isEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final isPushEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;

      if (!isEnabled || !isPushEnabled) return;

      final notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'body': description,
        'discount_code': discountCode,
        'channel': _promoChannel,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      await _sendPushNotification(notificationData);
      await _saveNotificationToHistory(notificationData);

      _notificationStreamController.add({
        'type': 'new_notification',
        'data': notificationData,
      });

      print('Promotional notification sent: $notificationData');
    } catch (e) {
      print('Failed to send promotional notification: $e');
    }
  }

  // Send health tip notification
  Future<void> sendHealthTipNotification({
    required String title,
    required String tip,
  }) async {
    try {
      final isEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final isPushEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;

      if (!isEnabled || !isPushEnabled) return;

      final notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'body': tip,
        'channel': _healthChannel,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      await _sendPushNotification(notificationData);
      await _saveNotificationToHistory(notificationData);

      _notificationStreamController.add({
        'type': 'new_notification',
        'data': notificationData,
      });

      print('Health tip notification sent: $notificationData');
    } catch (e) {
      print('Failed to send health tip notification: $e');
    }
  }

  // Send push notification (integration with flutter_local_notifications)
  Future<void> _sendPushNotification(Map<String, dynamic> notificationData) async {
    try {
      // This would integrate with flutter_local_notifications plugin
      // For now, we'll simulate the notification
      print('Push notification: ${notificationData['title']} - ${notificationData['body']}');
      
      // TODO: Integrate with flutter_local_notifications
      // await FlutterLocalNotificationsPlugin().show(
      //   notificationData['id'],
      //   notificationData['title'],
      //   notificationData['body'],
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       channelId: notificationData['channel'],
      //       importance: Importance.high,
      //       priority: Priority.high,
      //     ),
      //   ),
      // );
    } catch (e) {
      print('Failed to send push notification: $e');
    }
  }

  // Send email notification
  Future<void> _sendEmailNotification(Map<String, dynamic> notificationData) async {
    try {
      // This would integrate with email service
      print('Email notification: ${notificationData['title']} - ${notificationData['body']}');
      
      // TODO: Integrate with email service (sendgrid, mailgun, etc.)
      // await EmailService.sendNotification(
      //   to: await SecureStorageService.getUserEmail(),
      //   subject: notificationData['title'],
      //   body: notificationData['body'],
      // );
    } catch (e) {
      print('Failed to send email notification: $e');
    }
  }

  // Save notification to local history
  Future<void> _saveNotificationToHistory(Map<String, dynamic> notificationData) async {
    try {
      // Save to secure storage for notification history
      final existingHistory = await SecureStorageService.getNotificationHistory() ?? [];
      existingHistory.insert(0, notificationData);
      
      // Keep only last 100 notifications
      if (existingHistory.length > 100) {
        existingHistory.removeRange(100, existingHistory.length);
      }
      
      await SecureStorageService.saveNotificationHistory(existingHistory);
    } catch (e) {
      print('Failed to save notification to history: $e');
    }
  }

  // Get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      return await SecureStorageService.getNotificationHistory() ?? [];
    } catch (e) {
      print('Failed to get notification history: $e');
      return [];
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final history = await SecureStorageService.getNotificationHistory() ?? [];
      
      for (var notification in history) {
        if (notification['id'] == notificationId) {
          notification['read'] = true;
          break;
        }
      }
      
      await SecureStorageService.saveNotificationHistory(history);
      
      _notificationStreamController.add({
        'type': 'notification_read',
        'notification_id': notificationId,
      });
    } catch (e) {
      print('Failed to mark notification as read: $e');
    }
  }

  // Clear notification history
  Future<void> clearNotificationHistory() async {
    try {
      await SecureStorageService.saveNotificationHistory([]);
      
      _notificationStreamController.add({
        'type': 'history_cleared',
      });
    } catch (e) {
      print('Failed to clear notification history: $e');
    }
  }

  // Update notification settings
  Future<void> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
  }) async {
    try {
      if (notificationsEnabled != null) {
        await SecureStorageService.saveNotificationsEnabled(notificationsEnabled);
      }
      
      if (emailNotificationsEnabled != null) {
        await SecureStorageService.saveEmailNotificationsEnabled(emailNotificationsEnabled);
      }
      
      if (pushNotificationsEnabled != null) {
        await SecureStorageService.savePushNotificationsEnabled(pushNotificationsEnabled);
      }

      // Broadcast settings update
      _notificationStreamController.add({
        'type': 'settings_updated',
        'notifications_enabled': notificationsEnabled,
        'email_notifications_enabled': emailNotificationsEnabled,
        'push_notifications_enabled': pushNotificationsEnabled,
      });
    } catch (e) {
      print('Failed to update notification settings: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _notificationStreamController.close();
  }
}
