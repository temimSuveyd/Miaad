import 'package:doctorbooking/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:doctorbooking/features/home/presentation/widgets/home/upcoming_schedule_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../widgets/home/location_header_widget.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/categories_section_widget.dart';
import '../widgets/home/nearby_medical_centers_widget.dart';
import '../widgets/home/popular_doctors_section_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..subscribeToUserAppointments(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing8.dp),
                ),
                SliverToBoxAdapter(child: const LocationHeaderWidget()),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing8.dp),
                ),
                SliverToBoxAdapter(child: const SearchBarWidget()),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing12.dp),
                ),

                // Upcoming appointments (conditional)
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeAppointmentsLoaded &&
                        !state.hasUpcomingAppointments) {
                      return SliverToBoxAdapter(child: const SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: UpcomingScheduleCardWidget(),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing24.dp),
                ),
                SliverToBoxAdapter(child: const CategoriesSectionWidget()),

                // Popular Doctors Section
                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing24.dp),
                ),
                const SliverToBoxAdapter(child: PopularDoctorsSectionWidget()),

                SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacing24.dp),
                ),
                // SliverToBoxAdapter(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'المراكز الطبية القريبة',
                //         style: AppTheme.sectionTitle,
                //       ),
                //       TextButton(
                //         onPressed: () {},
                //         child: Text(
                //           'عرض الكل',
                //           style: AppTheme.bodyMedium.copyWith(
                //             color: AppTheme.textSecondary,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const NearbyMedicalCentersWidget(),
                // SliverToBoxAdapter(
                //   child: SizedBox(height: AppTheme.spacing24.dp),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
