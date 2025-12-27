import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/snackbar_service.dart';
import '../../cubit/appointment_cubit/appointments_cubit.dart';
import '../../cubit/appointment_cubit/appointments_state.dart';

// مستمع حالة المواعيد
class AppointmentsStateListener extends StatelessWidget {
  final Widget child;
  final String doctorName;

  const AppointmentsStateListener({
    super.key,
    required this.child,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        _handleState(context, state);
      },
      child: child,
    );
  }

  void _handleState(BuildContext context, AppointmentsState state) {
    if (state is AppointmentCreated) {
      _handleSuccess(context);
    } else if (state is AppointmentsError) {
      _handleError(context, state.message);
    }
  }

  void _handleSuccess(BuildContext context) {
    SnackbarService.showSuccess(
      context: context,
      title: 'تم الحجز بنجاح!',
      message: 'تم حجز موعدك مع $doctorName بنجاح',
    );
    Navigator.pop(context);
  }

  void _handleError(BuildContext context, String message) {
    SnackbarService.showError(context: context, title: 'خطأ', message: message);
  }
}
