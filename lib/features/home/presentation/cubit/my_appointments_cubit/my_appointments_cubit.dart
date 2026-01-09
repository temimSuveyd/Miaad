import 'dart:async';
import 'package:doctorbooking/features/home/data/mock/mock_doctor_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/appointments_model.dart';
import '../../../data/repositories/appointments_repositories.dart';
import 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final AppointmentsRepository repository;
  final String userId = MockDoctorData.userId;
  StreamSubscription? _appointmentsSubscription;

  MyAppointmentsCubit({required this.repository})
    : super(const MyAppointmentsInitial());

  // الاشتراك في مواعيد المستخدم - Subscribe to user appointments in real-time
  void subscribeToUserAppointments() {
    // إصدار حالة التحميل - Emit loading state
    emit(const MyAppointmentsLoading());

    // إلغاء الاشتراك السابق إن وجد - Cancel previous subscription if exists
    _appointmentsSubscription?.cancel();

    // الاشتراك في stream المواعيد - Subscribe to appointments stream
    _appointmentsSubscription = repository.getUserAppointmentsStream(userId).listen((
      result,
    ) {
      result.fold(
        // في حالة الخطأ - On error
        (failure) => emit(MyAppointmentsError(failure.message)),
        // في حالة النجاح - On success
        (appointments) {
          // تصنيف المواعيد حسب الحالة - Categorize appointments by status
          final upcoming = <AppointmentsModel>[];
          final completed = <AppointmentsModel>[];
          final cancelled = <AppointmentsModel>[];

          // فرز المواعيد حسب الحالة - Sort appointments by status
          for (final appointment in appointments) {
            switch (appointment.status) {
              case AppointmentStatus.upcoming:
              case AppointmentStatus.rescheduled:
                upcoming.add(appointment);
                break;
              case AppointmentStatus.completed:
                completed.add(appointment);
                break;
              case AppointmentStatus.cancelled:
                cancelled.add(appointment);
                break;
            }
          }

          // ترتيب المواعيد القادمة حسب التاريخ (الأقرب أولاً) - Sort upcoming by date (nearest first)
          upcoming.sort((a, b) => a.date.compareTo(b.date));

          // ترتيب المواعيد المكتملة والملغاة حسب التاريخ (الأحدث أولاً) - Sort completed/cancelled by date (newest first)
          completed.sort((a, b) => b.date.compareTo(a.date));
          cancelled.sort((a, b) => b.date.compareTo(a.date));

          // إصدار حالة التحميل الناجح - Emit loaded state
          emit(
            MyAppointmentsLoaded(
              upcomingAppointments: upcoming,
              completedAppointments: completed,
              cancelledAppointments: cancelled,
            ),
          );
        },
      );
    });
  }

  // تحميل مواعيد المستخدم (نفس الوظيفة مثل subscribeToUserAppointments)
  // Load user appointments (same functionality as subscribeToUserAppointments)
  void loadUserAppointments() {
    subscribeToUserAppointments();
  }

  // إلغاء موعد
  Future<void> cancelAppointment(String appointmentId) async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    emit(MyAppointmentCancelling(appointmentId));

    final result = await repository.cancelAppointment(appointmentId, userId);

    result.fold(
      (failure) {
        emit(
          MyAppointmentCancelError(
            message: failure.message,
            upcomingAppointments: currentState.upcomingAppointments,
            completedAppointments: currentState.completedAppointments,
            cancelledAppointments: currentState.cancelledAppointments,
          ),
        );
      },
      (cancelledAppointment) {
        // تحديث القوائم
        final upcoming = currentState.upcomingAppointments
            .where((a) => a.id != appointmentId)
            .toList();
        final cancelled = [
          cancelledAppointment,
          ...currentState.cancelledAppointments,
        ];

        emit(
          MyAppointmentCancelled(
            appointmentId: appointmentId,
            message: 'تم إلغاء الموعد بنجاح',
            upcomingAppointments: upcoming,
            completedAppointments: currentState.completedAppointments,
            cancelledAppointments: cancelled,
          ),
        );

        // العودة إلى حالة التحميل بعد ثانية
        Future.delayed(const Duration(seconds: 1), () {
          emit(
            MyAppointmentsLoaded(
              upcomingAppointments: upcoming,
              completedAppointments: currentState.completedAppointments,
              cancelledAppointments: cancelled,
            ),
          );
        });
      },
    );
  }

  // إعادة جدولة موعد
  Future<void> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    emit(const MyAppointmentsLoading());

    final result = await repository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
      userId,
    );

    result.fold((failure) => emit(MyAppointmentsError(failure.message)), (
      rescheduledAppointment,
    ) {
      // تحديث القوائم
      final upcoming = currentState.upcomingAppointments.map((a) {
        if (a.id == appointmentId) {
          return rescheduledAppointment;
        }
        return a;
      }).toList();

      upcoming.sort((a, b) => a.date.compareTo(b.date));

      emit(
        MyAppointmentsLoaded(
          upcomingAppointments: upcoming,
          completedAppointments: currentState.completedAppointments,
          cancelledAppointments: currentState.cancelledAppointments,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _appointmentsSubscription?.cancel();
    return super.close();
  }
}
