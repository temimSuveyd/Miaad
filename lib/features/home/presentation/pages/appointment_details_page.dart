import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/appointment_details/cubit/appointment_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';

import '../widgets/appointment_details/appointment_status_badge.dart';
import '../widgets/appointment_details/appointment_doctor_info_card.dart';
import '../widgets/appointment_details/appointment_details_card.dart';
import '../widgets/appointment_details/appointment_notes_card.dart';
import '../widgets/appointment_details/appointment_action_buttons.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AppointmentDetailsCubit>()..loadAppointmentFromArguments(),
      child: BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
        listener: (context, state) {
          if (state.hasSuccessMessage && state.successMessage != null) {
            SnackbarService.showSuccess(
              context: context,
              title: 'نجح',
              message: state.successMessage!,
            );
            if (state.successMessage!.contains('إلغاء') ||
                state.successMessage!.contains('جدولة')) {
              Get.back();
            }
          }
          if (state.hasError && state.errorMessage != null) {
            SnackbarService.showError(
              context: context,
              title: 'خطأ',
              message: state.errorMessage!,
            );
          }
        },
        builder: (context, state) {
          final currentAppointment = state.appointmentDetails?.appointment;

          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل الموعد'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل الموعد'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
              ),
              body: Center(child: Text(state.errorMessage ?? 'حدث خطأ ما')),
            );
          }

          if (currentAppointment == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل الموعد'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
              ),
              body: const Center(child: Text('لم يتم العثور على الموعد')),
            );
          }

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('تفاصيل الموعد'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing20),
                ),

                // Status Badge
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24,
                    ),
                    child: AppointmentStatusBadge(
                      appointment: currentAppointment,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing24),
                ),

                // Doctor Info Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24,
                    ),
                    child: AppointmentDoctorInfoCard(
                      appointment: currentAppointment,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing16),
                ),

                // Appointment Details Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24,
                    ),
                    child: AppointmentDetailsCard(
                      appointment: currentAppointment,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing16),
                ),

                // Notes Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24,
                    ),
                    child: AppointmentNotesCard(
                      appointment: currentAppointment,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing16),
                ),

                // Action Buttons
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing24,
                    ),
                    child: AppointmentActionButtons(
                      appointment: currentAppointment,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing32),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
