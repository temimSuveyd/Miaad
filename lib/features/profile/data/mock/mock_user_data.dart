import '../models/user_model.dart';

class MockUserData {
  static const String currentUserId = 'user_001';

  static final UserModel currentUser = UserModel(
    id: currentUserId,
    name: 'Daniel Martinez',
    email: 'daniel.martinez@example.com',
    phone: '+123 856479683',
    profileImage:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
    dateOfBirth: DateTime(1990, 5, 15),
    gender: 'Male',
    address: '123 Main Street, New York, NY 10001',
    createdAt: DateTime(2023, 1, 15),
    updatedAt: DateTime.now(),
  );

  static final List<UserModel> allUsers = [
    currentUser,
    UserModel(
      id: 'user_002',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@example.com',
      phone: '+123 456789012',
      profileImage:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
      dateOfBirth: DateTime(1985, 8, 22),
      gender: 'Female',
      address: '456 Oak Avenue, Los Angeles, CA 90210',
      createdAt: DateTime(2023, 2, 10),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: 'user_003',
      name: 'Michael Chen',
      email: 'michael.chen@example.com',
      phone: '+123 789012345',
      profileImage:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
      dateOfBirth: DateTime(1992, 12, 3),
      gender: 'Male',
      address: '789 Pine Street, Chicago, IL 60601',
      createdAt: DateTime(2023, 3, 5),
      updatedAt: DateTime.now(),
    ),
  ];

  // Get user by ID
  static UserModel? getUserById(String id) {
    try {
      return allUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  static UserModel updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
  }) {
    final user = getUserById(userId);
    if (user == null) throw Exception('User not found');

    final updatedUser = user.copyWith(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      updatedAt: DateTime.now(),
    );

    // Update in the list
    final index = allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      allUsers[index] = updatedUser;
    }

    return updatedUser;
  }
}
