import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
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

    return Column(
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
        SizedBox(height: AppTheme.spacing12.dp),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppTheme.spacing4.dp,
            mainAxisSpacing: AppTheme.spacing4.dp,
            childAspectRatio: 0.75,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
          },
        ),
      ],
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
              width: 70.dp,
              height: 70.dp,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall.dp),
              ),
              child: Icon(category.icon, color: Colors.white, size: 32.dp),
            ),
            Positioned(
              top: -25.dp,
              left: -25.dp,
              child: Container(
                width: 60.dp,
                height: 60.dp,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(100.dp),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacing8.dp),
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
