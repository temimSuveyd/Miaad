import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/repositories/settings_repository.dart';

// Profile States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileUpdated extends ProfileState {
  final UserModel user;

  const ProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Profile Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String? email;
  final String phone;
  final String city;

  const UpdateProfile({
    required this.name,
    this.email,
    required this.phone,
    required this.city,
  });

  @override
  List<Object?> get props => [name, email, phone, city];
}

// Profile Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final SettingsRepository _repository;

  ProfileCubit({required SettingsRepository repository})
      : _repository = repository,
        super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await UserService.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> updateProfile({
    required String name,
    String? email,
    required String phone,
    required String city,
    String? dateOfBirth,
  }) async {
    emit(ProfileLoading());
    try {
      final userId = await UserService.getCurrentUserId();
      
      // Update profile in backend
      final updatedUser = await _repository.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        city: city,

      );

      // Update secure storage
      await SecureStorageService.saveUserData(updatedUser);

      emit(ProfileUpdated(updatedUser));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }
}
