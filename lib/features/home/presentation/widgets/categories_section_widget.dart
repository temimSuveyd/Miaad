import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'category_item_widget.dart';

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': 'assets/icons/cardiology.svg', 'label': 'Cardiologist'},
      {'icon': 'assets/icons/kidney.svg', 'label': 'Kidney'},
      {'icon': 'assets/icons/liver.svg', 'label': 'Liver'},
      {'icon': 'assets/icons/ophthalmology.svg', 'label': 'ENT'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing4),
              child: CategoryItemWidget(
                iconPath: category['icon']!,
                label: category['label']!,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}