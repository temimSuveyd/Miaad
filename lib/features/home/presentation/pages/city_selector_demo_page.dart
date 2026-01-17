import 'package:flutter/material.dart';
import '../../../../core/data/syrian_cities.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/buttons/city_selector_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Demo page to show city selector usage
class CitySelectorDemoPage extends StatefulWidget {
  const CitySelectorDemoPage({super.key});

  @override
  State<CitySelectorDemoPage> createState() => _CitySelectorDemoPageState();
}

class _CitySelectorDemoPageState extends State<CitySelectorDemoPage> {
  String? selectedCity;
  SyrianCity? selectedCityObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(title: 'اختيار المدينة', showleading: true),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text('معلومات الموقع', style: AppTheme.heading2),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'اختر المدينة التي تريد البحث فيها عن الأطباء',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            // City Selector Button
            CitySelectorButton(
              selectedCity: selectedCity,
              label: 'المدينة',
              onCitySelected: (city) {
                setState(() {
                  selectedCity = city.nameAr;
                  selectedCityObject = city;
                });
              },
            ),

            const SizedBox(height: AppTheme.spacing32),

            // Selected City Info Card
            if (selectedCityObject != null)
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing20),
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
                      'المدينة المختارة',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSmall,
                            ),
                          ),
                          child: const Icon(
                            Icons.location_city,
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
                                selectedCityObject!.nameAr,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing4),
                              Text(
                                'المحافظة: ${selectedCityObject!.governorate}',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                'English: ${selectedCityObject!.nameEn}',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // Save Button
            if (selectedCity != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم حفظ المدينة: $selectedCity'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'حفظ',
                    style: AppTheme.bodyLarge.copyWith(
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
}
