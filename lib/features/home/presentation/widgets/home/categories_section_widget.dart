import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/error_state_widget.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../shared/specialities/presentation/cubit/specialities_cubit.dart';
import '../../../../shared/specialities/presentation/cubit/specialities_state.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem(this.name, this.icon, this.color);
}

class _SpecialityCard extends StatelessWidget {
  final String name;
  final String icon;
  final Color color;

  const _SpecialityCard({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 55.dp,
              height: 55.dp,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall.dp),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: TextStyle(fontSize: 28.dp),
              ),
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
          name,
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

class _SpecialityShimmerCard extends StatelessWidget {
  const _SpecialityShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 55.dp,
          height: 55.dp,
          decoration: BoxDecoration(
            color: AppTheme.dividerColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall.dp),
          ),
        ),
        SizedBox(height: AppTheme.spacing8.dp),
        Container(
          width: 45.dp,
          height: 10.dp,
          decoration: BoxDecoration(
            color: AppTheme.dividerColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(6.dp),
          ),
        ),
      ],
    );
  }
}

Color _colorForIndex(int index) {
  const colors = [
    AppTheme.categoryPink,
    AppTheme.categoryGreen,
    AppTheme.categoryOrange,
    AppTheme.categoryPurple,
    AppTheme.categoryTeal,
    AppTheme.categoryNavy,
    AppTheme.categoryBeige,
    AppTheme.categoryLightBlue,
  ];
  return colors[index % colors.length];
}

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SharedSpecialitiesCubit>()..loadSpecialities(),
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
          SizedBox(height: AppTheme.spacing12.dp),
          BlocBuilder<SharedSpecialitiesCubit, SpecialitiesState>(
            builder: (context, state) {
              if (state is SpecialitiesLoading) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppTheme.spacing4.dp,
                    mainAxisSpacing: AppTheme.spacing4.dp,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return const _SpecialityShimmerCard();
                  },
                );
              }

              if (state is SpecialitiesError) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing16,
                  ),
                  child: ErrorStateWidget(
                    title: 'خطأ في تحميل التخصصات',
                    message: state.message,
                    icon: Icons.category_rounded,
                    onRetry: () {
                      context.read<SharedSpecialitiesCubit>().loadSpecialities();
                    },
                    retryButtonText: 'إعادة التحميل',
                  ),
                );
              }

              if (state is SpecialitiesLoaded) {
                final specialities = state.specialities;
                if (specialities.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing16,
                    ),
                    child: const EmptyStateWidget(
                      title: 'لا توجد تخصصات',
                      message: 'لا توجد تخصصات متاحة في الوقت الحالي',
                      icon: Icons.category_outlined,
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppTheme.spacing4.dp,
                    mainAxisSpacing: AppTheme.spacing4.dp,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: specialities.length,
                  itemBuilder: (context, index) {
                    final speciality = specialities[index];
                    return _SpecialityCard(
                      name: speciality.name,
                      icon: speciality.icon,
                      color: _colorForIndex(index),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
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
              width: 55.dp,
              height: 55.dp,
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
