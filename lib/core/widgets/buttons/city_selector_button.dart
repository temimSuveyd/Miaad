import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/syrian_cities.dart';
import '../../theme/app_theme.dart';
import '../bottom_sheets/city_selector_bottom_sheet.dart';

/// Button widget to select a city
class CitySelectorButton extends StatelessWidget {
  final String? selectedCity;
  final Function(SyrianCity city) onCitySelected;
  final String? label;
  final bool showLabel;

  const CitySelectorButton({
    super.key,
    this.selectedCity,
    required this.onCitySelected,
    this.label,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: AppTheme.sectionTitle.copyWith(fontSize: 16)),
          const SizedBox(height: AppTheme.spacing12),
        ],
        InkWell(
          onTap: () => _showCitySelector(context),
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
                  Iconsax.location5,
                  color: selectedCity != null
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    selectedCity ?? 'اختر المدينة',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selectedCity != null
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCitySelector(BuildContext context) async {
    final result = await CitySelectorBottomSheet.show(
      context: context,
      selectedCity: selectedCity,
    );

    if (result != null) {
      onCitySelected(result);
    }
  }
}
