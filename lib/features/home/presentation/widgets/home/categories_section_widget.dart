import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem(this.name, this.icon, this.color);
}

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryItem> categories = [
      CategoryItem(
        'طب الأسنان',
        Icons.medical_services_outlined,
        AppTheme.categoryPink,
      ),
      CategoryItem('القلب', Icons.favorite_outline, AppTheme.categoryGreen),
      CategoryItem('الرئة', Icons.air_outlined, AppTheme.categoryOrange),
      CategoryItem(
        'عام',
        Icons.health_and_safety_outlined,
        AppTheme.categoryPurple,
      ),
      CategoryItem(
        'الأعصاب',
        Icons.psychology_alt_outlined,
        AppTheme.categoryTeal,
      ),
      CategoryItem(
        'الجهاز الهضمي',
        Icons.restaurant_outlined,
        AppTheme.categoryNavy,
      ),
      CategoryItem('المختبر', Icons.science_outlined, AppTheme.categoryBeige),
      CategoryItem(
        'التطعيم',
        Icons.vaccines_outlined,
        AppTheme.categoryLightBlue,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('التخصصات', style: AppTheme.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.spacing4,
              mainAxisSpacing: AppTheme.spacing4,
              childAspectRatio: 0.75,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(category: category);
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryItem category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(category.icon, color: Colors.white, size: 32),
            ),
            Positioned(
              top: -25,
              left: -25,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          category.name,
          style: AppTheme.caption.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
