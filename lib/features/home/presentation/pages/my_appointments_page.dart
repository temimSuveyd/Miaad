import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/features/home/presentation/widgets/my_appointments/appointment_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/my_appointments_cubit/my_appointments_cubit.dart';
import '../cubit/my_appointments_cubit/my_appointments_state.dart';
import '../widgets/my_appointments/appointment_card_widget.dart';
import '../widgets/my_appointments/my_appointments_shimmer_widget.dart';

class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MyAppointmentsCubit>()..subscribeToUserAppointments(),
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<MyAppointmentsCubit>().subscribeToUserAppointments();
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: MyAppointmentAppBar(context),
            body: BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
              listener: (context, state) {
                // عرض رسالة عند نجاح الإلغاء
                if (state is MyAppointmentCancelled) {
                  SnackbarService.showSuccess(
                    title: 'نجح',
                    message: 'تم إلغاء الموعد بنجاح',
                  );
                }
                // عرض رسالة عند فشل الإلغاء
                if (state is MyAppointmentCancelError) {
                  SnackbarService.showError(
                    context: context,
                    title: 'خطأ',
                    message: 'فشل في إلغاء الموعد، يرجى المحاولة مرة أخرى',
                  );
                }
              },
              builder: (context, state) {
                // حالة التحميل
                if (state is MyAppointmentsLoading) {
                  return const TabBarView(
                    children: [
                      MyAppointmentsShimmerWidget(),
                      MyAppointmentsShimmerWidget(),
                      MyAppointmentsShimmerWidget(),
                    ],
                  );
                }

                // حالة الخطأ
                if (state is MyAppointmentsError) {
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
                          state.message,
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
                                .subscribeToUserAppointments();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor2,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // حالة تحميل المواعيد أو حالات النجاح/الفشل مع البيانات
                if (state is MyAppointmentsLoaded ||
                    state is MyAppointmentCancelled ||
                    state is MyAppointmentCancelError) {
                  // استخراج البيانات من الحالة المناسبة
                  final upcomingAppointments = state is MyAppointmentsLoaded
                      ? state.upcomingAppointments
                      : state is MyAppointmentCancelled
                      ? state.upcomingAppointments
                      : (state as MyAppointmentCancelError)
                            .upcomingAppointments;

                  final completedAppointments = state is MyAppointmentsLoaded
                      ? state.completedAppointments
                      : state is MyAppointmentCancelled
                      ? state.completedAppointments
                      : (state as MyAppointmentCancelError)
                            .completedAppointments;

                  final cancelledAppointments = state is MyAppointmentsLoaded
                      ? state.cancelledAppointments
                      : state is MyAppointmentCancelled
                      ? state.cancelledAppointments
                      : (state as MyAppointmentCancelError)
                            .cancelledAppointments;

                  return TabBarView(
                    children: [
                      _buildAppointmentsList(
                        upcomingAppointments,
                        isUpcoming: true,
                      ),
                      _buildAppointmentsList(
                        completedAppointments,
                        isCompleted: true,
                      ),
                      _buildAppointmentsList(
                        cancelledAppointments,
                        isCancelled: true,
                      ),
                    ],
                  );
                }

                // الحالة الأولية
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  // بناء قائمة المواعيد
  Widget _buildAppointmentsList(
    List appointments, {
    bool isUpcoming = false,
    bool isCompleted = false,
    bool isCancelled = false,
  }) {
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
              'No appointments found',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
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
            isUpcoming: isUpcoming,
            isCompleted: isCompleted,
            isCancelled: isCancelled,
          ),
        );
      },
    );
  }
}
