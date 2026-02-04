import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/services/snackbar_service.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/features/profile/data/mock/mock_user_data.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/widgets/doctor_booking_bottom_bar.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/widgets/weekly_schedule.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/widgets/no_slots_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookAppointmentCubit>()
        ..startBooking(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'حجز موعد', showleading: true),
        body: BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
          listener: (context, state) {
            if (state.isBookingComplete) {
              SnackbarService.showSuccess(
                context: context,
                title: 'نجح',
                message: state.successMessage ?? 'تم حجز الموعد بنجاح',
              );
              Navigator.of(context).pop();
            }
            if (state.hasError) {
              SnackbarService.showError(
                context: context,
                title: 'خطأ',
                message: state.errorMessage!,
              );
            }
          },
          builder: (context, state) {
            if (!state.isBookingStarted) {
              return const Center(child: CircularProgressIndicator());
            }

            // التحقق من عدم وجود ساعات عمل
            if (state.noWorkingHours) {
              return NoWorkingHoursWidget(
                onRetry: () => context.read<BookAppointmentCubit>().startBooking(),
              );
            }

            // التحقق من عدم وجود سلوتس متاحة
            if (state.noSlotsAvailable) {
              return NoAvailableSlotsWidget(
                onRetry: () => context.read<BookAppointmentCubit>().startBooking(),
              );
            }

            // Tatil günü kontrolü - sadece slot yoksa göster
            if (state.isTodayHoliday && !state.hasAvailableSlots) {
              return _buildHolidayView(context, state);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacing24),

                    // الجدول الأسبوعي للمواعيد
                    WeeklySchedule(),

                    const SizedBox(height: AppTheme.spacing24),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar:
            BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
              builder: (context, state) {
                // عدم عرض bottom bar في حالات معينة
                if ((state.isTodayHoliday && !state.hasAvailableSlots) || state.noWorkingHours || state.noSlotsAvailable) {
                  return const SizedBox.shrink();
                }

                final cubit = context.read<BookAppointmentCubit>();

                // تحديد حالة الزر
                bool canBook = false;
                String title = 'اختر التاريخ والوقت';
                Color? color;

                if (state.hasError) {
                  title = 'حدث خطأ';
                  color = AppTheme.errorColor;
                  canBook = false;
                } else if (state.selectedDate != null &&
                    state.selectedTime != null) {
                  title = 'تأكيد الحجز';
                  canBook = true;
                } else if (state.selectedDate != null) {
                  title = 'اختر الوقت';
                  canBook = false;
                }

                return DoctorBookingBottomBar(
                  title: title,
                  onBookPressed: () => cubit.confirmBooking(MockUserData.currentUserId),
                  canBook: canBook,
                  isLoading: state.isLoading,
                  color: color,
                );
              },
            ),
      ),
    );
  }

  /// بناء عرض العطلة
  Widget _buildHolidayView(BuildContext context, BookAppointmentState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة العطلة
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            // عنوان العطلة
            Text(
              'يوم عطلة',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: AppTheme.spacing16),

            // رسالة العطلة
            Text(
              state.holidayMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacing32),

            // معلومات إضافية
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: Text(
                          'يمكنك حجز موعد في أيام العمل',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    _getWorkingHoursText(state),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            // زر العودة
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing16,
                  ),
                ),
                child: Text(
                  'العودة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الحصول على نص أوقات العمل
  String _getWorkingHoursText(BookAppointmentState state) {
    if (state.bookingModel?.workHours != null) {
      final workHours = state.bookingModel!.workHours!;
      final workingDays = workHours.workingDays;

      if (workingDays.isNotEmpty) {
        final dayNames = {
          'Mon': 'الاثنين',
          'Tue': 'الثلاثاء',
          'Wed': 'الأربعاء',
          'Thu': 'الخميس',
          'Fri': 'الجمعة',
          'Sat': 'السبت',
          'Sun': 'الأحد',
        };

        final arabicDays = workingDays
            .map((day) => dayNames[day] ?? day)
            .join(' - ');

        return 'أيام العمل: $arabicDays';
      }
    }

    // النص الافتراضي
    return 'أوقات العمل: الأحد - الخميس من 9:00 صباحاً إلى 5:00 مساءً';
  }
}
