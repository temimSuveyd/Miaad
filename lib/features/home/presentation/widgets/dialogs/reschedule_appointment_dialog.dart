import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../appointments/data/models/appointment.dart';

class RescheduleAppointmentDialog extends StatefulWidget {
  final AppointmentModel appointment;
  final Function(DateTime newDate, String newTime) onReschedule;

  const RescheduleAppointmentDialog({
    super.key,
    required this.appointment,
    required this.onReschedule,
  });

  static void show({
    required BuildContext context,
    required AppointmentModel appointment,
    required Function(DateTime newDate, String newTime) onReschedule,
  }) {
    showDialog(
      context: context,
      builder: (context) => RescheduleAppointmentDialog(
        appointment: appointment,
        onReschedule: onReschedule,
      ),
    );
  }

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.appointment.date;
    selectedTime = DateFormatter.formatTimeString(widget.appointment.time);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 650),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and close button
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.calendar_edit5,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text('إعادة جدولة الموعد', style: AppTheme.heading2),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 24,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Current Appointment Info
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموعد الحالي',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar_1,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        DateFormatter.formatAppointmentDate(
                          widget.appointment.date,
                        ),
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing16),
                      Icon(
                        Iconsax.clock,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        DateFormatter.formatTimeString(widget.appointment.time),
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Select New Date
            Text(
              'اختر تاريخ جديد',
              style: AppTheme.sectionTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppTheme.spacing12),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  border: Border.all(color: AppTheme.dividerColor),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      color: AppTheme.primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      selectedDate != null
                          ? DateFormatter.formatAppointmentDate(selectedDate!)
                          : 'اختر التاريخ',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacing20),

            // Select New Time
            Text(
              'اختر وقت جديد',
              style: AppTheme.sectionTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppTheme.spacing12),

            // Time Slots Grid
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: AppTheme.spacing8,
                  mainAxisSpacing: AppTheme.spacing8,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final time = timeSlots[index];
                  final isSelected = selectedTime == time;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(
                        color: AppTheme.dividerColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canConfirm()
                        ? () {
                            widget.onReschedule(selectedDate!, selectedTime!);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تأكيد',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool _canConfirm() {
    if (selectedDate == null || selectedTime == null) return false;
    return selectedDate != widget.appointment.date ||
        selectedTime != DateFormatter.formatTimeString(widget.appointment.time);
  }
}
