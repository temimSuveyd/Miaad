import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/category_local_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import 'category_item_widget.dart';

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryService = CategoryService(
      localDataSource: CategoryLocalDataSourceImpl(),
    );
    final categories = categoryService.getCategories();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(
                right: index < categories.length - 1 ? AppTheme.spacing12 : 0,
              ),
              child: CategoryItemWidget(
                // iconPath: 'assets/icons/${category.icon}',
                iconPath: 'assets/icons/gynecology.png',
                label: category.title,
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
