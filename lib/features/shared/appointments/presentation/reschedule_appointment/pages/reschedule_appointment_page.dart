import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/service_locator.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../data/models/appointment.dart';
import '../cubit/reschedule_appointment_cubit.dart';

class RescheduleAppointmentPage extends StatelessWidget {
  const RescheduleAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from appointment card
    final arguments = Get.arguments as Map<String, dynamic>?;
    final appointment = arguments?['appointment'] as AppointmentModel?;

    if (appointment == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('إعادة جدولة الموعد'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text('لم يتم العثور على معلومات الموعد'),
        ),
      );
    }

    return BlocProvider(
      create: (context) => sl<RescheduleAppointmentCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعادة جدولة الموعد'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appointment info card
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات الموعد الحالي',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildInfoRow(
                      context,
                      'الطبيب',
                      appointment.doctorName ?? 'غير محدد',
                    ),
                    _buildInfoRow(
                      context,
                      'المستشفى',
                      appointment.hospitalName ?? 'غير محدد',
                    ),
                    _buildInfoRow(
                      context,
                      'التاريخ',
                      appointment.formattedDate,
                    ),
                    _buildInfoRow(
                      context,
                      'الوقت',
                      appointment.formattedTime,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Reschedule options
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خيارات إعادة الجدولة',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      
                      // Quick reschedule options
                      _buildRescheduleOption(
                        context,
                        'غداً',
                        'إعادة جدولة ليوم الغد',
                        Icons.calendar_today,
                        () {
                          // TODO: Implement tomorrow reschedule
                          _showComingSoon(context);
                        },
                      ),
                      
                      _buildRescheduleOption(
                        context,
                        'الأسبوع القادم',
                        'إعادة جدولة للأسبوع القادم',
                        Icons.date_range,
                        () {
                          // TODO: Implement next week reschedule
                          _showComingSoon(context);
                        },
                      ),
                      
                      _buildRescheduleOption(
                        context,
                        'اختر تاريخ ووقت',
                        'اختر تاريخ ووقت جديدين',
                        Icons.schedule,
                        () {
                          // TODO: Navigate to slot selection
                          _showComingSoon(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRescheduleOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                 Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('هذه الميزة ستكون متاحة قريباً'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
