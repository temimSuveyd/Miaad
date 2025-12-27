import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../cubit/home_cubit/home_state.dart';
import '../widgets/home/header_widget.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/categories_section_widget.dart';
import '../widgets/home/upcoming_schedule_card_widget.dart';
import '../widgets/home/popular_doctors_section_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..fetchUserAppointments(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: AppTheme.spacing16),
                const SearchBarWidget(),
                const SizedBox(height: AppTheme.spacing24),
                const CategoriesSectionWidget(),
                const SizedBox(height: AppTheme.spacing32),

                // قسم المواعيد القادمة
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    // إخفاء القسم إذا لم تكن هناك مواعيد قادمة
                    if (state is HomeAppointmentsLoaded &&
                        !state.hasUpcomingAppointments) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        // العنوان مع العداد
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Upcoming Schedule',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(width: AppTheme.spacing8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: AppTheme.spacing4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.textSecondary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusSmall,
                                  ),
                                ),
                                child: Text(
                                  state is HomeAppointmentsLoaded
                                      ? '${state.upcomingCount}'
                                      : '0',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        // البطاقات
                        const UpcomingScheduleCardWidget(),
                        const SizedBox(height: AppTheme.spacing32),
                      ],
                    );
                  },
                ),

                // قسم الأطباء المشهورين
                const PopularDoctorsSectionWidget(),
                const SizedBox(height: AppTheme.spacing20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
