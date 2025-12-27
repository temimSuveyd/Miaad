import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/appointments_model.dart';
import '../../../data/repositories/appointments_repositories.dart';
import 'appointments_state.dart';

// إدارة حالة المواعيد
class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentsRepository repository;

  DateTime? _selectedDate;
  String? _selectedTime;

  AppointmentsCubit({required this.repository}) : super(AppointmentsInitial());

  // تحديد التاريخ والوقت
  void selectDateTime({DateTime? date, String? time}) {
    if (date != null) _selectedDate = date;
    if (time != null) _selectedTime = time;

    emit(
      AppointmentDateTimeSelected(
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
      ),
    );
  }

  // إنشاء موعد جديد
  Future<void> createAppointment({
    required String userId,
    required String doctorId,
    String? notes,
  }) async {
    if (_selectedDate == null || _selectedTime == null) {
      emit(const AppointmentsError('الرجاء تحديد التاريخ والوقت'));
      return;
    }

    emit(AppointmentsLoading());

    // إنشاء موعد مع بيانات مؤقتة
    final appointment = AppointmentsModel(
      doctorName: 'Rimes Suveyd',
      hospitalName: 'El Razi Hastanesi',
      userName: 'Temim Suved',
      userId: userId,
      doctorId: doctorId,
      date: _selectedDate!,
      time: _selectedTime!,
      status: AppointmentStatus.upcoming,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final result = await repository.createAppointment(appointment);

    result.fold((failure) => emit(AppointmentsError(failure.message)), (
      createdAppointment,
    ) {
      emit(AppointmentCreated(createdAppointment));
      // إعادة تعيين التاريخ والوقت
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  // إلغاء الموعد
  Future<void> cancelAppointment(String appointmentId, String userId) async {
    emit(AppointmentsLoading());

    final result = await repository.cancelAppointment(appointmentId, userId);

    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (cancelledAppointment) => emit(AppointmentCreated(cancelledAppointment)),
    );
  }

  // إعادة جدولة الموعد
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTime,
    required String userId,
  }) async {
    emit(AppointmentsLoading());

    final result = await repository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
      userId,
    );

    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (rescheduledAppointment) =>
          emit(AppointmentCreated(rescheduledAppointment)),
    );
  }

  // إعادة تعيين الحالة
  void resetState() {
    _selectedDate = null;
    _selectedTime = null;
    emit(AppointmentsInitial());
  }

  // التحقق من إمكانية الحجز
  bool canBook() {
    final currentState = state;
    return currentState is AppointmentDateTimeSelected && currentState.canBook;
  }

  // التحقق من حالة التحميل
  bool isLoading() {
    return state is AppointmentsLoading;
  }
}
