import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/notification_service.dart';

// Settings States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;

  const SettingsLoaded({
    required this.notificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
  });

  @override
  List<Object> get props => [notificationsEnabled, emailNotificationsEnabled, pushNotificationsEnabled];

  SettingsLoaded copyWith({
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
  }) {
    return SettingsLoaded(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// Settings Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ToggleEmailNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleEmailNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class TogglePushNotifications extends SettingsEvent {
  final bool enabled;

  const TogglePushNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class SignOut extends SettingsEvent {}

// Settings Cubit
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final notificationsEnabled = await SecureStorageService.getNotificationsEnabled() ?? true;
      final emailNotificationsEnabled = await SecureStorageService.getEmailNotificationsEnabled() ?? true;
      final pushNotificationsEnabled = await SecureStorageService.getPushNotificationsEnabled() ?? true;

      // Initialize notification service
      await NotificationService().initialize();

      emit(SettingsLoaded(
        notificationsEnabled: notificationsEnabled,
        emailNotificationsEnabled: emailNotificationsEnabled,
        pushNotificationsEnabled: pushNotificationsEnabled,
      ));
    } catch (e) {
      emit(SettingsError('Failed to load settings: ${e.toString()}'));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (state is SettingsLoaded) {
      try {
        await NotificationService().updateNotificationSettings(
          notificationsEnabled: enabled,
        );
        emit((state as SettingsLoaded).copyWith(notificationsEnabled: enabled));
      } catch (e) {
        emit(SettingsError('Failed to update notifications: ${e.toString()}'));
      }
    }
  }

  Future<void> toggleEmailNotifications(bool enabled) async {
    if (state is SettingsLoaded) {
      try {
        await NotificationService().updateNotificationSettings(
          emailNotificationsEnabled: enabled,
        );
        emit((state as SettingsLoaded).copyWith(emailNotificationsEnabled: enabled));
      } catch (e) {
        emit(SettingsError('Failed to update email notifications: ${e.toString()}'));
      }
    }
  }

  Future<void> togglePushNotifications(bool enabled) async {
    if (state is SettingsLoaded) {
      try {
        await NotificationService().updateNotificationSettings(
          pushNotificationsEnabled: enabled,
        );
        emit((state as SettingsLoaded).copyWith(pushNotificationsEnabled: enabled));
      } catch (e) {
        emit(SettingsError('Failed to update push notifications: ${e.toString()}'));
      }
    }
  }

  // Send appointment notification
  Future<void> sendAppointmentNotification({
    required String doctorName,
    required String appointmentTime,
    required String appointmentDate,
  }) async {
    try {
      await NotificationService().sendAppointmentNotification(
        doctorName: doctorName,
        appointmentTime: appointmentTime,
        appointmentDate: appointmentDate,
      );
    } catch (e) {
      emit(SettingsError('Failed to send appointment notification: ${e.toString()}'));
    }
  }

  // Send message notification
  Future<void> sendMessageNotification({
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    try {
      await NotificationService().sendMessageNotification(
        senderName: senderName,
        message: message,
        senderAvatar: senderAvatar,
      );
    } catch (e) {
      emit(SettingsError('Failed to send message notification: ${e.toString()}'));
    }
  }

  // Get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      return await NotificationService().getNotificationHistory();
    } catch (e) {
      emit(SettingsError('Failed to get notification history: ${e.toString()}'));
      return [];
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await NotificationService().markNotificationAsRead(notificationId);
    } catch (e) {
      emit(SettingsError('Failed to mark notification as read: ${e.toString()}'));
    }
  }

  // Clear notification history
  Future<void> clearNotificationHistory() async {
    try {
      await NotificationService().clearNotificationHistory();
    } catch (e) {
      emit(SettingsError('Failed to clear notification history: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    try {
      emit(SettingsLoading());
      await SecureStorageService.clearAll();
      emit(SettingsInitial());
    } catch (e) {
      emit(SettingsError('Failed to sign out: ${e.toString()}'));
    }
  }
}
