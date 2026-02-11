import '../datasources/settings_datasource.dart';
import '../../../auth/data/models/user_model.dart';

abstract class SettingsRepository {
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    String? email,
    required String phone,
    required String city,
  });

  Future<UserModel> getUserProfile(String userId);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepositoryImpl({required SettingsDataSource dataSource})
      : _dataSource = dataSource;

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
      return await _dataSource.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        city: city,
   
      );
    } catch (e) {
      throw Exception('Repository error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      return await _dataSource.getUserProfile(userId);
    } catch (e) {
      throw Exception('Repository error: ${e.toString()}');
    }
  }
}
