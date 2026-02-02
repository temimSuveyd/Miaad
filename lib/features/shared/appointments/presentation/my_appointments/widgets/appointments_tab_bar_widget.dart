import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubit/my_appointments_cubit.dart';

class AppointmentsTabBarWidget extends StatelessWidget {
  const AppointmentsTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
      builder: (context, state) {
        final counts = context
            .read<MyAppointmentsCubit>()
            .getAppointmentCounts();

        return Container(
          color: Colors.white,
          child: TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            onTap: (index) {
              final filter = AppointmentFilter.values[index];
              context.read<MyAppointmentsCubit>().applyFilter(filter);
            },
            tabs: [
              // Tab(
              //   child: _buildTabWithCount(
              //     'الكل',
              //     counts[AppointmentFilter.all] ?? 0,
              //   ),
              // ),
              Tab(
                child: _buildTabWithCount(
                  'القادمة',
                  counts[AppointmentFilter.upcoming] ?? 0,
                ),
              ),
              Tab(
                child: _buildTabWithCount(
                  'المكتملة',
                  counts[AppointmentFilter.completed] ?? 0,
                ),
              ),
              Tab(
                child: _buildTabWithCount(
                  'الملغية',
                  counts[AppointmentFilter.cancelled] ?? 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabWithCount(String title, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        // if (count > 0) ...[
        //   const SizedBox(width: 4),
        //   Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        //     decoration: BoxDecoration(
        //       color: AppTheme.primaryColor,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Text(
        //       count.toString(),
          
        //       style: const TextStyle(
        //         color: Colors.white,
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }
}
