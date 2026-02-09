import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/features/shared/appointments/data/models/appointment.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/my_appointments/widgets/appointment_app_bar.dart';
import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubit/my_appointments_cubit.dart';
import '../widgets/appointment_card_widget.dart';
import '../widgets/my_appointments_shimmer_widget.dart';

class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyAppointmentsCubit>(),
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<MyAppointmentsCubit>().refreshAppointments();
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: MyAppointmentAppBar(context),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
                    listener: (context, state) {
                      // عرض رسالة عند نجاح العملية
                      if (state.hasSuccessMessage) {
                        SnackbarService.showSuccess(
                          context: context,
                          title: 'نجح',
                          message: state.successMessage!,
                        );
                        context.read<MyAppointmentsCubit>().clearMessages();
                      }
                      // عرض رسالة عند فشل العملية
                      if (state.hasError) {
                        SnackbarService.showError(
                          context: context,
                          title: 'خطأ',
                          message: state.errorMessage!,
                        );
                        context.read<MyAppointmentsCubit>().clearMessages();
                      }
                    },
                    builder: (context, state) {
                      // حالة التحميل
                      if (state.isLoading && !state.hasAppointments) {
                        return const TabBarView(
                          children: [
                            MyAppointmentsShimmerWidget(),
                            MyAppointmentsShimmerWidget(),
                            MyAppointmentsShimmerWidget(),
                            MyAppointmentsShimmerWidget(),
                          ],
                        );
                      }

                      // حالة الخطأ بدون بيانات
                      if (state.hasError && !state.hasAppointments) {
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
                                      .read<MyAppointmentsCubit>()
                                      .refreshAppointments();
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

                      // عرض البيانات
                      return TabBarView(
                        children: [
                          // _buildAppointmentsList(
                          //   context,
                          //   state.filteredAppointments,
                          //   AppointmentFilter.all,
                          // ),
                          _buildAppointmentsList(
                            context,
                            state.appointments
                                .where(
                                  (appointment) =>
                                      appointment.appointment.status ==
                                          AppointmentStatus.upcoming ||
                                      appointment.appointment.status ==
                                          AppointmentStatus.rescheduled,
                                )
                                .toList(),
                            AppointmentFilter.upcoming,
                          ),
                          _buildAppointmentsList(
                            context,
                            state.appointments
                                .where(
                                  (appointment) =>
                                      appointment.appointment.status ==
                                      AppointmentStatus.completed,
                                )
                                .toList(),
                            AppointmentFilter.completed,
                          ),
                          _buildAppointmentsList(
                            context,
                            state.appointments
                                .where(
                                  (appointment) =>
                                      appointment.appointment.status ==
                                      AppointmentStatus.cancelled,
                                )
                                .toList(),
                            AppointmentFilter.cancelled,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // بناء قائمة المواعيد
  Widget _buildAppointmentsList(
    BuildContext context,
    List appointments,
    AppointmentFilter filter,
  ) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              _getEmptyMessage(filter),
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
          child: AppointmentCardWidget(
            appointment: appointment,
            onCancel: (appointmentId) {
              context.read<MyAppointmentsCubit>().cancelAppointment(
                appointmentId,
              );
            },
            onReschedule: (appointmentId, newDate, newTime) {
              context.read<MyAppointmentsCubit>().rescheduleAppointment(
                appointmentId,
                newDate,
                newTime,
              );
            },
          ),
        );
      },
    );
  }

  String _getEmptyMessage(AppointmentFilter filter) {
    switch (filter) {
      case AppointmentFilter.all:
        return 'لا توجد مواعيد';
      case AppointmentFilter.upcoming:
        return 'لا توجد مواعيد قادمة';
      case AppointmentFilter.completed:
        return 'لا توجد مواعيد مكتملة';
      case AppointmentFilter.cancelled:
        return 'لا توجد مواعيد ملغية';
    }
  }
}
