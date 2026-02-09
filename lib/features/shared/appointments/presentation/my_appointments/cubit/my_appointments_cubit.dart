import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/services/user_service.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/models/my_appointment_model.dart';
import '../../../data/models/appointment.dart';

part 'my_appointments_state.dart';

/// Cubit لإدارة مواعيد المستخدم
/// My Appointments Cubit - Manages user appointments
class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final SharedAppointmentRepository repository;
  StreamSubscription<dynamic>? _appointmentsSubscription;
  String? _currentUserId;

  MyAppointmentsCubit({required this.repository})
    : super(const MyAppointmentsState()) {
    _loadUserId();
  }

  /// تحميل معرف المستخدم الحالي
  Future<void> _loadUserId() async {
    try {
      _currentUserId = await UserService.getCurrentUserId();
      // بعد تحميل معرف المستخدم، ابدأ تحميل المواعيد
      if (_currentUserId != null) {
        loadUserAppointmentsStream();
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'User not logged in',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load user ID',
      ));
    }
  }

  /// تحميل مواعيد المستخدم
  Future<void> loadUserAppointments() async {
    if (_currentUserId == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User not logged in',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.getUserAppointments(_currentUserId!);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointments) {
        final myAppointments = appointments
            .map(
              (appointment) => MyAppointmentModel.fromAppointment(appointment),
            )
            .toList();

        emit(
          state.copyWith(
            isLoading: false,
            appointments: myAppointments,
            filteredAppointments: _filterAppointments(
              myAppointments,
              state.selectedFilter,
            ),
          ),
        );
      },
    );
  }

  /// تحميل مواعيد المستخدم مع real-time updates
  void loadUserAppointmentsStream() {
    if (_currentUserId == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User not logged in',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    _appointmentsSubscription?.cancel();
    _appointmentsSubscription = repository
        .getUserAppointmentsStream(_currentUserId!)
        .listen(
          (result) {
            result.fold(
              (failure) => emit(
                state.copyWith(isLoading: false, errorMessage: failure.message),
              ),
              (appointments) {
                final myAppointments = appointments
                    .map(
                      (appointment) =>
                          MyAppointmentModel.fromAppointment(appointment),
                    )
                    .toList();

                emit(
                  state.copyWith(
                    isLoading: false,
                    appointments: myAppointments,
                    filteredAppointments: _filterAppointments(
                      myAppointments,
                      state.selectedFilter,
                    ),
                  ),
                );
              },
            );
          },
          onError: (error) => emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'خطأ في تحميل المواعيد: $error',
            ),
          ),
        );
  }

  /// تطبيق فلتر على المواعيد
  void applyFilter(AppointmentFilter filter) {
    final filteredAppointments = _filterAppointments(
      state.appointments,
      filter,
    );
    emit(
      state.copyWith(
        selectedFilter: filter,
        filteredAppointments: filteredAppointments,
      ),
    );
  }

  /// إلغاء موعد
  Future<void> cancelAppointment(String appointmentId) async {
    if (_currentUserId == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User not logged in',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.cancelAppointment(appointmentId, _currentUserId!);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (updatedAppointment) {
        // تحديث الموعد في القائمة
        final updatedAppointments = state.appointments.map((myAppointment) {
          if (myAppointment.appointment.id == appointmentId) {
            return MyAppointmentModel.fromAppointment(updatedAppointment);
          }
          return myAppointment;
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            appointments: updatedAppointments,
            filteredAppointments: _filterAppointments(
              updatedAppointments,
              state.selectedFilter,
            ),
            successMessage: 'تم إلغاء الموعد بنجاح',
          ),
        );
      },
    );
  }

  /// إعادة جدولة موعد
  Future<void> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) async {
    if (_currentUserId == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User not logged in',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
      _currentUserId!,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (updatedAppointment) {
        // تحديث الموعد في القائمة
        final updatedAppointments = state.appointments.map((myAppointment) {
          if (myAppointment.appointment.id == appointmentId) {
            return MyAppointmentModel.fromAppointment(updatedAppointment);
          }
          return myAppointment;
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            appointments: updatedAppointments,
            filteredAppointments: _filterAppointments(
              updatedAppointments,
              state.selectedFilter,
            ),
            successMessage: 'تم إعادة جدولة الموعد بنجاح',
          ),
        );
      },
    );
  }

  /// تحديث المواعيد
  Future<void> refreshAppointments() async {
    await _loadUserId();
  }

  /// مسح رسائل النجاح والخطأ
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  /// فلترة المواعيد حسب النوع
  List<MyAppointmentModel> _filterAppointments(
    List<MyAppointmentModel> appointments,
    AppointmentFilter filter,
  ) {
    switch (filter) {
      case AppointmentFilter.all:
        return appointments;
      case AppointmentFilter.upcoming:
        return appointments
            .where(
              (appointment) =>
                  appointment.appointment.status ==
                      AppointmentStatus.upcoming ||
                  appointment.appointment.status ==
                      AppointmentStatus.rescheduled,
            )
            .toList();
      case AppointmentFilter.completed:
        return appointments
            .where(
              (appointment) =>
                  appointment.appointment.status == AppointmentStatus.completed,
            )
            .toList();
      case AppointmentFilter.cancelled:
        return appointments
            .where(
              (appointment) =>
                  appointment.appointment.status == AppointmentStatus.cancelled,
            )
            .toList();
    }
  }

  /// الحصول على عدد المواعيد لكل فلتر
  Map<AppointmentFilter, int> getAppointmentCounts() {
    return {
      AppointmentFilter.all: state.appointments.length,
      AppointmentFilter.upcoming: _filterAppointments(
        state.appointments,
        AppointmentFilter.upcoming,
      ).length,
      AppointmentFilter.completed: _filterAppointments(
        state.appointments,
        AppointmentFilter.completed,
      ).length,
      AppointmentFilter.cancelled: _filterAppointments(
        state.appointments,
        AppointmentFilter.cancelled,
      ).length,
    };
  }

  @override
  Future<void> close() {
    _appointmentsSubscription?.cancel();
    return super.close();
  }
}
