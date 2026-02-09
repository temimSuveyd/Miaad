import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userCityKey = 'user_city';
  static const String _userTokenKey = 'user_token';

  // Save user data after successful sign in
  static Future<void> saveUserData(UserModel user) async {
    try {
      await _storage.write(key: _userIdKey, value: user.id);
      await _storage.write(key: _userEmailKey, value: user.email ?? '');
      await _storage.write(key: _userNameKey, value: user.name);
      await _storage.write(key: _userCityKey, value: user.city);
      
      // Also save the access token if available from Supabase
      // This will be useful for API calls
      // await _storage.write(key: _userTokenKey, value: user.accessToken);
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

      if (userId != null && userName != null) {
        return UserModel(
          id: userId,
          name: userName,
          email: userEmail,
          phone: '', // Phone not stored in secure storage
          city: userCity ?? '',
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
}
