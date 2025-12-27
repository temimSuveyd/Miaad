import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/theme/app_theme.dart';

// شريط الحجز السفلي
class DoctorBookingBottomBar extends StatelessWidget {
  final VoidCallback onBookPressed;
  final VoidCallback onMessagePressed;
  final bool canBook;
  final bool isLoading;

  const DoctorBookingBottomBar({
    super.key,
    required this.onBookPressed,
    required this.onMessagePressed,
    required this.canBook,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildMessageButton(),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(child: _buildBookButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: IconButton(
        onPressed: onMessagePressed,
        icon: const Icon(
          Iconsax.message,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: canBook && !isLoading ? onBookPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          disabledBackgroundColor: AppTheme.textSecondary.withValues(
            alpha: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Book Now',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
