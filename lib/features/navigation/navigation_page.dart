import 'package:doctorbooking/core/widgets/bottom_navigation_bar.dart';
import 'package:doctorbooking/features/home/presentation/pages/home_page.dart';
import 'package:doctorbooking/features/profile/presentation/pages/settings_page.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/my_appointments/page/my_appointments_page.dart';
import 'package:doctorbooking/features/search/presentation/pages/search_page.dart';
import 'package:doctorbooking/features/my_doctors/presentation/pages/saved_page.dart';
import 'package:doctorbooking/features/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  // List of pages for navigation
  static final List<Widget> _pages = [
    const HomePage(),
    const MyAppointmentsPage(),
    const SearchPage(),
    const SavedPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: state.currentIndex, children: _pages),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<NavigationCubit>().changeTab(index);
              },
            ),
          );
        },
      ),
    );
  }
}
