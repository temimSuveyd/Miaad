import 'package:doctorbooking/features/home/data/models/appointments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../cubit/home_cubit/home_cubit.dart';
import '../../cubit/home_cubit/home_state.dart';
import 'schedule_shimmer_widget.dart';

class UpcomingScheduleCardWidget extends StatefulWidget {
  const UpcomingScheduleCardWidget({super.key});

  @override
  State<UpcomingScheduleCardWidget> createState() =>
      _UpcomingScheduleCardWidgetState();
}

class _UpcomingScheduleCardWidgetState
    extends State<UpcomingScheduleCardWidget> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // حالة التحميل
        if (state is HomeLoading) {
          return const ScheduleShimmerWidget();
        }

        // حالة الخطأ - إخفاء القسم
        if (state is HomeError) {
          return const SizedBox.shrink();
        }

        // حالة تحميل المواعيد
        if (state is HomeAppointmentsLoaded) {
          final upcomingAppointments = state.upcomingAppointments;

          // إخفاء القسم إذا لم تكن هناك مواعيد
          if (upcomingAppointments.isEmpty) {
            return const SizedBox.shrink();
          }

          // إذا كان هناك موعد واحد فقط، عرضه بدون CardSwiper
          if (upcomingAppointments.length == 1) {
            return SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildScheduleCard(upcomingAppointments[0]),
              ),
            );
          }

          // إذا كان هناك أكثر من موعد، استخدم CardSwiper
          return SizedBox(
            height: 160,
            child: CardSwiper(
              controller: controller,
              cardsCount: upcomingAppointments.length,
              numberOfCardsDisplayed: 2,
              backCardOffset: const Offset(0, 20),
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              duration: const Duration(milliseconds: 100),
              maxAngle: 10,
              threshold: 50,
              scale: 0.9,
              isLoop: true,
              allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                horizontal: true,
              ),
              cardBuilder:
                  (
                    context,
                    index,
                    horizontalOffsetPercentage,
                    verticalOffsetPercentage,
                  ) {
                    final appointment = upcomingAppointments[index];
                    return _buildScheduleCard(appointment);
                  },
            ),
          );
        }

        // الحالة الأولية - إخفاء القسم
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildScheduleCard(AppointmentsModel appointment) {
    // تنسيق التاريخ باستخدام DateFormatter
    final formattedDate = DateFormatter.formatShort(appointment.date);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor2.withOpacity(0.6),
                AppTheme.primaryColor2,

                // AppTheme.primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة الطبيب
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    // معلومات الطبيب
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${appointment.doctorName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'الموعد القادم',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // أيقونة الفيديو
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                // التاريخ والوقت
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        appointment.time,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
