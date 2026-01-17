import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/dialogs/base_dialog.dart';

class CancelAppointmentDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CancelAppointmentDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CancelAppointmentDialog(
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm();
        },
        onCancel: () {
          Navigator.of(context).pop(false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      icon: const DialogIcon(
        icon: Icons.warning_amber_rounded,
        color: AppTheme.errorColor,
      ),
      title: 'إلغاء الموعد',
      subtitle:
          'هل أنت متأكد من إلغاء هذا الموعد؟ لا يمكن التراجع عن هذا الإجراء.',
      content: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: AppTheme.errorColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.errorColor, size: 20),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                'سيتم إلغاء الموعد بشكل نهائي ولن تتمكن من استرجاعه',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [_buildCancelButton(), _buildConfirmButton()],
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: onCancel,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        side: const BorderSide(color: AppTheme.dividerColor, width: 1.5),
      ),
      child: Text(
        'تراجع',
        style: AppTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.errorColor,
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        elevation: 0,
      ),
      child: Text(
        'نعم، إلغاء الموعد',
        style: AppTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
