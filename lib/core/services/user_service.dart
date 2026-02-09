import 'package:doctorbooking/features/auth/data/models/user_model.dart';
import 'package:doctorbooking/core/services/secure_storage_service.dart';

class UserService {
  // Get current user ID
  static Future<String> getCurrentUserId() async {
    final userId = await SecureStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in');
    }
    return userId;
  }

  // Get current user data
  static Future<UserModel> getCurrentUser() async {
    final userData = await SecureStorageService.getUserData();
    if (userData == null) {
      throw Exception('User not logged in');
    }
    return userData;
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    return await SecureStorageService.isUserLoggedIn();
  }

  // Get current user name
  static Future<String> getCurrentUserName() async {
    final userName = await SecureStorageService.getUserName();
    if (userName == null || userName.isEmpty) {
      throw Exception('User not logged in');
    }
    return userName;
  }

  // Get current user email
  static Future<String> getCurrentUserEmail() async {
    final userEmail = await SecureStorageService.getUserEmail();
    if (userEmail == null || userEmail.isEmpty) {
      throw Exception('User not logged in');
    }
    return userEmail;
  }

  // Get current user city
  static Future<String> getCurrentUserCity() async {
    final userCity = await SecureStorageService.getUserCity();
    return userCity ?? '';
  }
}
