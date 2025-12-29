import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../cubit/home_cubit/home_state.dart';
import '../widgets/home/location_header_widget.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/categories_section_widget.dart';
import '../widgets/home/nearby_medical_centers_widget.dart';
import '../widgets/home/upcoming_schedule_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..subscribeToUserAppointments(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacing8),
                const LocationHeaderWidget(),
                const SizedBox(height: AppTheme.spacing8),
                const SearchBarWidget(),
                const SizedBox(height: AppTheme.spacing12),

                // Upcoming appointments (conditional)
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeAppointmentsLoaded &&
                        !state.hasUpcomingAppointments) {
                      return const SizedBox.shrink();
                    }
                    return UpcomingScheduleCardWidget();
                  },
                ),

                const CategoriesSectionWidget(),
                const SizedBox(height: AppTheme.spacing24),
                const NearbyMedicalCentersWidget(),
                const SizedBox(height: AppTheme.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
