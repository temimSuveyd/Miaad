import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../data/models/appointment_details_model.dart';
import '../cubit/appointment_details_cubit.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailsPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AppointmentDetailsCubit>()..loadAppointmentDetails(appointmentId),
      child: Scaffold(
        appBar: CustomAppBar(title: 'تفاصيل الموعد', showleading: true),
        body: BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
          listener: (context, state) {
            if (state.hasSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<AppointmentDetailsCubit>().clearMessages();
            }
            if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<AppointmentDetailsCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            if (state.isLoading && !state.hasAppointmentDetails) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.hasError && !state.hasAppointmentDetails) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.errorColor,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppointmentDetailsCubit>()
                            .refreshAppointmentDetails(appointmentId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (!state.hasAppointmentDetails) {
              return const Center(child: Text('لا توجد تفاصيل للموعد'));
            }

            final details = state.appointmentDetails!;
            final appointment = details.appointment;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات الموعد الأساسية
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName ?? 'Unknown Doctor',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppTheme.spacing8),
                          Text(
                            appointment.hospitalName ?? 'Unknown Hospital',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: AppTheme.spacing16),
                          Row(
                            children: [
                              Icon(
                                appointment.getStatusIcon(),
                                color: appointment.getStatusColor(),
                                size: 20,
                              ),
                              const SizedBox(width: AppTheme.spacing8),
                              Text(
                                appointment.getStatusText(),
                                style: TextStyle(
                                  color: appointment.getStatusColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacing16),

                  // تفاصيل الموعد
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفاصيل الموعد',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppTheme.spacing16),
                          _buildDetailRow('التاريخ', appointment.formattedDate),
                          _buildDetailRow('الوقت', appointment.formattedTime),
                          if (appointment.notes != null &&
                              appointment.notes!.isNotEmpty)
                            _buildDetailRow('الملاحظات', appointment.notes!),
                        ],
                      ),
                    ),
                  ),

                  // معلومات إضافية
                  if (details.hasAdditionalInfo) ...[
                    const SizedBox(height: AppTheme.spacing16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معلومات إضافية',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppTheme.spacing16),
                            ...details.additionalInfo.entries.map(
                              (entry) =>
                                  _buildDetailRow(entry.key, entry.value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // الإجراءات المتاحة
                  if (details.hasAvailableActions) ...[
                    const SizedBox(height: AppTheme.spacing16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الإجراءات المتاحة',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppTheme.spacing16),
                            ...details.availableActions.map(
                              (action) => ListTile(
                                leading: Icon(
                                  _getActionIcon(action),
                                  color: AppTheme.primaryColor,
                                ),
                                title: Text(action.displayName),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  context
                                      .read<AppointmentDetailsCubit>()
                                      .executeAction(
                                        action,
                                        appointmentId,
                                        'current_user_id',
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacing32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon(AppointmentAction action) {
    switch (action) {
      case AppointmentAction.reschedule:
        return Icons.schedule;
      case AppointmentAction.cancel:
        return Icons.cancel;
      case AppointmentAction.viewReceipt:
        return Icons.receipt;
      case AppointmentAction.rateDoctor:
        return Icons.star;
      case AppointmentAction.contactDoctor:
        return Icons.phone;
      case AppointmentAction.getDirections:
        return Icons.directions;
    }
  }
}
