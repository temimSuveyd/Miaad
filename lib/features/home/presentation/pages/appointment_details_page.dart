import 'package:doctorbooking/features/shared/appointments/presentation/appointment_details/cubit/appointment_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../shared/appointments/data/models/appointment.dart';

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
    // Load appointment details when page is first built
    context.read<AppointmentDetailsCubit>().loadAppointmentDetails(appointment.id!);

    return BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
      listener: (context, state) {
        if (state.hasSuccessMessage && state.successMessage != null) {
          SnackbarService.showSuccess(context: context, title: 'نجح', message: state.successMessage!);
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
        final currentAppointment = state.appointment ?? appointment;
        
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
                  child: AppointmentStatusBadge(appointment: currentAppointment),
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
                  child: AppointmentDetailsCard(appointment: currentAppointment),
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
                  child: AppointmentNotesCard(appointment: currentAppointment),
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
    );
  }
}
