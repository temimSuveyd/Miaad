import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/categories_section_widget.dart';
import '../widgets/upcoming_schedule_card_widget.dart';
import '../widgets/popular_doctors_section_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
                child: Row(
                  children: [
                    Text(
                      'Upcoming Schedule',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        '3',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              const UpcomingScheduleCardWidget(),
              const SizedBox(height: AppTheme.spacing32),
              const PopularDoctorsSectionWidget(),
              const SizedBox(height: AppTheme.spacing20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}