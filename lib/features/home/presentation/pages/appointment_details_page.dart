import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../appointments/data/models/appointment.dart';
import '../cubit/appointment_details_cubit/appointment_details_cubit.dart';
import '../cubit/appointment_details_cubit/appointment_details_state.dart';
import '../widgets/appointment_details/appointment_status_badge.dart';
import '../widgets/appointment_details/appointment_doctor_info_card.dart';
import '../widgets/appointment_details/appointment_details_card.dart';
import '../widgets/appointment_details/appointment_notes_card.dart';
import '../widgets/appointment_details/appointment_action_buttons.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
      listener: (context, state) {
        if (state is AppointmentDetailsCancelled) {
          SnackbarService.showSuccess(title: 'نجح', message: state.message);
          Get.back();
        }
        if (state is AppointmentDetailsCancelError) {
          SnackbarService.showError(
            context: context,
            title: 'خطأ',
            message: state.message,
          );
        }
        if (state is AppointmentDetailsRescheduled) {
          SnackbarService.showSuccess(title: 'نجح', message: state.message);
          Get.back();
        }
        if (state is AppointmentDetailsRescheduleError) {
          SnackbarService.showError(
            context: context,
            title: 'خطأ',
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: CustomAppBar(title: 'تفاصيل الموعد', showleading: true),
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
                  child: AppointmentStatusBadge(appointment: state.appointment),
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
                    appointment: state.appointment,
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
                  child: AppointmentDetailsCard(appointment: state.appointment),
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
                  child: AppointmentNotesCard(appointment: state.appointment),
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
                    appointment: state.appointment,
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
    );
  }
}
