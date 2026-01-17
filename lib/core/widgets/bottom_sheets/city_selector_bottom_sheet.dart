import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/syrian_cities.dart';
import '../../theme/app_theme.dart';

class CitySelectorBottomSheet extends StatefulWidget {
  final String? selectedCity;
  final Function(SyrianCity city) onCitySelected;

  const CitySelectorBottomSheet({
    super.key,
    this.selectedCity,
    required this.onCitySelected,
  });

  static Future<SyrianCity?> show({
    required BuildContext context,
    String? selectedCity,
  }) {
    return showModalBottomSheet<SyrianCity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CitySelectorBottomSheet(
        selectedCity: selectedCity,
        onCitySelected: (city) {
          Navigator.pop(context, city);
        },
      ),
    );
  }

  @override
  State<CitySelectorBottomSheet> createState() =>
      _CitySelectorBottomSheetState();
}

class _CitySelectorBottomSheetState extends State<CitySelectorBottomSheet> {
  String searchQuery = '';
  String? selectedGovernorate;
  List<SyrianCity> filteredCities = SyrianCities.cities;

  @override
  void initState() {
    super.initState();
    _filterCities();
  }

  void _filterCities() {
    setState(() {
      if (searchQuery.isEmpty && selectedGovernorate == null) {
        filteredCities = SyrianCities.cities;
      } else if (searchQuery.isNotEmpty) {
        filteredCities = SyrianCities.searchCities(searchQuery);
      } else if (selectedGovernorate != null) {
        filteredCities = SyrianCities.cities
            .where((city) => city.governorate == selectedGovernorate)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppTheme.spacing12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppTheme.spacing16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.location5,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('اختر المدينة', style: AppTheme.heading2),
                      Text(
                        '${filteredCities.length} مدينة',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacing20),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                selectedGovernorate = null;
                _filterCities();
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن مدينة...',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal_1,
                  color: AppTheme.textSecondary,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                            _filterCities();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing12,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing16),

          // Governorate Filter Chips
          if (searchQuery.isEmpty)
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing24,
                ),
                itemCount: SyrianCities.governorates.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildFilterChip(
                      label: 'الكل',
                      isSelected: selectedGovernorate == null,
                      onTap: () {
                        setState(() {
                          selectedGovernorate = null;
                          _filterCities();
                        });
                      },
                    );
                  }
                  final governorate = SyrianCities.governorates[index - 1];
                  return _buildFilterChip(
                    label: governorate,
                    isSelected: selectedGovernorate == governorate,
                    onTap: () {
                      setState(() {
                        selectedGovernorate = governorate;
                        _filterCities();
                      });
                    },
                  );
                },
              ),
            ),

          const SizedBox(height: AppTheme.spacing16),

          // Divider
          const Divider(height: 1, color: AppTheme.dividerColor),

          // Cities List
          Expanded(
            child: filteredCities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing8,
                    ),
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = filteredCities[index];
                      final isSelected = widget.selectedCity == city.nameAr;

                      return _buildCityItem(
                        city: city,
                        isSelected: isSelected,
                        onTap: () => widget.onCitySelected(city),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.spacing8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityItem({
    required SyrianCity city,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing24,
          vertical: AppTheme.spacing16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // City Icon
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                Iconsax.buildings_25,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),

            // City Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.nameAr,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    city.governorate,
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Selected Indicator
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_status,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'لا توجد نتائج',
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'جرب البحث بكلمات أخرى',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
