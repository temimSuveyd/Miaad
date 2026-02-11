import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../auth/data/models/user_model.dart';

abstract class SettingsDataSource {
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    String? email,
    required String phone,
    required String city,
  });

  Future<UserModel> getUserProfile(String userId);
}

class SettingsDataSourceImpl implements SettingsDataSource {
  final SupabaseClient _client;

  SettingsDataSourceImpl() : _client = SupabaseConfig.client;

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    String? email,
    required String phone,
    required String city,
    String? dateOfBirth,
  }) async {
    try {
      // Get current user data to preserve existing fields
      final currentUser = await getUserProfile(userId);
      
      // Create UserModel with updated data
      final updatedUser = UserModel(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        city: city,
        imageUrl: currentUser.imageUrl ?? '', // Keep existing image URL
        dateOfBirth: currentUser.dateOfBirth ??DateTime.now(), // Use new date or keep existing
        gender: currentUser.gender ?? '', // Keep existing gender
      );

      final response = await _client
          .from('users')
          .update(updatedUser.toJson())
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }
}
