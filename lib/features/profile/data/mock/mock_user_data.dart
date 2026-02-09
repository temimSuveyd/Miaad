import '../models/user_model.dart';

class MockUserData {
  static const String currentUserId = '5a4b4fc1-4c58-4d2c-baac-ef050fce8ce3';

  static final UserModel currentUser = UserModel(
    id: currentUserId,
    name: 'Daniel Martinez',
    email: 'daniel.martinez@example.com',
    phone: '+123 856479683',
    profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
    createdAt: DateTime(2023, 1, 15),
    updatedAt: DateTime.now(),
  );

  // Get user by ID
  static UserModel? getUserById(String id) {
    if (id == currentUserId) {
      return currentUser;
    }
    return null;
  }

  // Update user profile
  static UserModel updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    final user = getUserById(userId);
    if (user == null) throw Exception('User not found');

    return user.copyWith(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      updatedAt: DateTime.now(),
    );
  }
}
