import 'package:doctorbooking/features/shared/appointments/data/models/appointment_details_model.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/appointment_details/cubit/appointment_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/appointments/data/models/appointment.dart';
import '../dialogs/cancel_appointment_dialog.dart';
import '../dialogs/reschedule_appointment_dialog.dart';

class AppointmentActionButtons extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentActionButtons({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    if (appointment.status != AppointmentStatus.upcoming) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
      builder: (context, state) {
        final isLoading = state.isActionLoading;

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
                icon: state.isActionLoading && state.selectedAction == AppointmentAction.reschedule
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
                  state.isActionLoading && state.selectedAction == AppointmentAction.reschedule
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
                icon: state.isActionLoading && state.selectedAction == AppointmentAction.cancel
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
                  state.isActionLoading && state.selectedAction == AppointmentAction.cancel
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
    final cubit = context.read<AppointmentDetailsCubit>();
    CancelAppointmentDialog.show(
      context: context,
      onConfirm: () {
        cubit.cancelAppointment(
          appointment.id!,
          'patient', // TODO: Get actual user ID
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context) {
    final cubit = context.read<AppointmentDetailsCubit>();
    RescheduleAppointmentDialog.show(
      context: context,
      appointment: appointment,
      onReschedule: (newDate, newTime) {
        cubit.rescheduleAppointment(
          appointment.id!,
          newDate,
          newTime,
          'patient', // TODO: Get actual user ID
        );
        Navigator.pop(context);
      },
    );
  }
}
