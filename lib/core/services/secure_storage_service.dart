import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userCityKey = 'user_city';
  static const String _userBirthdayKey = 'user_birthday';
  static const String _userPhoneKey = 'user_phone';
  static const String _userTokenKey = 'user_token';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _emailNotificationsEnabledKey =
      'email_notifications_enabled';
  static const String _pushNotificationsEnabledKey =
      'push_notifications_enabled';
  static const String _notificationHistoryKey = 'notification_history';

  // Save user data after successful sign in
  static Future<void> saveUserData(UserModel user) async {
    try {
      await _storage.write(key: _userIdKey, value: user.id);
      await _storage.write(key: _userEmailKey, value: user.email ?? '');
      await _storage.write(key: _userNameKey, value: user.name);
      await _storage.write(key: _userCityKey, value: user.city);
      await _storage.write(key: _userPhoneKey, value: user.phone);
      await _storage.write(
        key: _userBirthdayKey,
        value: user.dateOfBirth.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      return null;
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: _userEmailKey);
    } catch (e) {
      return null;
    }
  }

  // Get user name
  static Future<String?> getUserName() async {
    try {
      return await _storage.read(key: _userNameKey);
    } catch (e) {
      return null;
    }
  }

  // Get user city
  static Future<String?> getUserCity() async {
    try {
      return await _storage.read(key: _userCityKey);
    } catch (e) {
      return null;
    }
  }

  // Get all user data as UserModel
  static Future<UserModel?> getUserData() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      final userEmail = await _storage.read(key: _userEmailKey);
      final userName = await _storage.read(key: _userNameKey);
      final userCity = await _storage.read(key: _userCityKey);
      final userBirthday = await _storage.read(key: _userBirthdayKey);
      final userPhone = await _storage.read(key: _userPhoneKey);

      if (userId != null &&
          userName != null &&
          userCity != null &&
          userBirthday != null &&
          userPhone != null) {
        final dateOfBirth = DateTime.parse(userBirthday);
        return UserModel(
          id: userId,
          name: userName,
          email: userEmail,
          phone: userPhone,
          city: userCity,
          dateOfBirth: dateOfBirth,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    try {
      await _storage.delete(key: _userIdKey);
      await _storage.delete(key: _userEmailKey);
      await _storage.delete(key: _userNameKey);
      await _storage.delete(key: _userCityKey);
      await _storage.delete(key: _userTokenKey);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }

  // Clear all storage (for testing or debugging)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear all storage: $e');
    }
  }

  // Notification Settings Methods
  static Future<bool?> getNotificationsEnabled() async {
    try {
      final value = await _storage.read(key: _notificationsEnabledKey);
      return value != null ? bool.tryParse(value) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveNotificationsEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: _notificationsEnabledKey,
        value: enabled.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save notifications setting: $e');
    }
  }

  static Future<bool?> getEmailNotificationsEnabled() async {
    try {
      final value = await _storage.read(key: _emailNotificationsEnabledKey);
      return value != null ? bool.tryParse(value) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveEmailNotificationsEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: _emailNotificationsEnabledKey,
        value: enabled.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save email notifications setting: $e');
    }
  }

  static Future<bool?> getPushNotificationsEnabled() async {
    try {
      final value = await _storage.read(key: _pushNotificationsEnabledKey);
      return value != null ? bool.tryParse(value) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> savePushNotificationsEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: _pushNotificationsEnabledKey,
        value: enabled.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save push notifications setting: $e');
    }
  }

  // Notification History Methods
  static Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final historyJson = await _storage.read(key: _notificationHistoryKey);
      if (historyJson == null) return [];

      final List<dynamic> historyList = [];
      // For now, return empty list - in real implementation, this would parse JSON
      return historyList.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveNotificationHistory(
    List<Map<String, dynamic>> history,
  ) async {
    try {
      final historyJson = history.map((item) => item.toString()).toList();
      await _storage.write(
        key: _notificationHistoryKey,
        value: historyJson.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save notification history: $e');
    }
  }
}
