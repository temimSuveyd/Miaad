import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// حوار تأكيد الحجز
class BookingConfirmationDialog extends StatelessWidget {
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTime;
  final String userId;
  final String doctorId;
  final Function() onConfirm;

  const BookingConfirmationDialog({
    super.key,
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTime,
    required this.userId,
    required this.doctorId,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      title: const Text(
        'تأكيد الحجز',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'هل تريد حجز موعد مع $doctorName في ${selectedDate.toString().split(' ')[0]} الساعة $selectedTime؟',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
          child: const Text(
            'تأكيد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String doctorName,
    required DateTime selectedDate,
    required String selectedTime,
    required String userId,
    required String doctorId,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => BookingConfirmationDialog(
        doctorName: doctorName,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        userId: userId,
        doctorId: doctorId,
        onConfirm: () => onConfirm(),
      ),
    );
  }
}
