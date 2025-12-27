import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../../core/theme/app_theme.dart';

class UpcomingScheduleCardWidget extends StatefulWidget {
  const UpcomingScheduleCardWidget({super.key});

  @override
  State<UpcomingScheduleCardWidget> createState() =>
      _UpcomingScheduleCardWidgetState();
}

class _UpcomingScheduleCardWidgetState
    extends State<UpcomingScheduleCardWidget> {
  final CardSwiperController controller = CardSwiperController();

  final List<Map<String, String>> schedules = [
    {
      'name': 'Prof. Dr. Logan Mason',
      'specialty': 'Dentist',
      'date': 'June 12',
      'time': '9:30 AM',
      'image':
          'https://tse3.mm.bing.net/th/id/OIP.9mHnGxjdY7Xb7-y-aq0_qQHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
    },
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'date': 'June 15',
      'time': '2:00 PM',
      'image':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Pediatrician',
      'date': 'June 18',
      'time': '11:00 AM',
      'image':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: CardSwiper(
        controller: controller,
        cardsCount: schedules.length,
        numberOfCardsDisplayed: 2,
        backCardOffset: const Offset(0, 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        duration: const Duration(milliseconds: 200),
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
              final schedule = schedules[index];
              return _buildScheduleCard(schedule);
            },
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, String> schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(schedule['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      schedule['specialty']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
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
                  schedule['date']!,
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
                  schedule['time']!,
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
    );
  }
}
