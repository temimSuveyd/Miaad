import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/appointments_model.dart';
import '../../cubit/appointment_details_cubit/appointment_details_cubit.dart';
import '../../cubit/appointment_details_cubit/appointment_details_state.dart';
import '../dialogs/cancel_appointment_dialog.dart';
import '../dialogs/reschedule_appointment_dialog.dart';

class AppointmentActionButtons extends StatelessWidget {
  final AppointmentsModel appointment;

  const AppointmentActionButtons({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    if (appointment.status != AppointmentStatus.upcoming) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
      builder: (context, state) {
        final isLoading =
            state is AppointmentDetailsCancelling ||
            state is AppointmentDetailsRescheduling;

        return Column(
          children: [
            // Reschedule Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _showRescheduleDialog(context),
                icon: state is AppointmentDetailsRescheduling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.update_outlined),
                label: Text(
                  state is AppointmentDetailsRescheduling
                      ? 'جاري إعادة الجدولة...'
                      : 'إعادة جدولة الموعد',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => _showCancelDialog(context),
                icon: state is AppointmentDetailsCancelling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.errorColor,
                          ),
                        ),
                      )
                    : const Icon(Icons.cancel_outlined),
                label: Text(
                  state is AppointmentDetailsCancelling
                      ? 'جاري الإلغاء...'
                      : 'إلغاء الموعد',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                  side: const BorderSide(
                    color: AppTheme.errorColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context) {
    CancelAppointmentDialog.show(
      context: context,
      onConfirm: () {
        context.read<AppointmentDetailsCubit>().cancelAppointment();
      },
    );
  }

  void _showRescheduleDialog(BuildContext context) {
    RescheduleAppointmentDialog.show(
      context: context,
      appointment: appointment,
      onReschedule: (newDate, newTime) {
        context.read<AppointmentDetailsCubit>().rescheduleAppointment(
          newDate,
          newTime,
        );
        Navigator.pop(context);
      },
    );
  }
}
