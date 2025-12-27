import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/navigation/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/home/presentation/pages/doctor_detail_page.dart';

/// Route configuration for the application
class RouteConfigPage {
  /// Get all configured routes
  static List<GetPage> getPages() {
    return [
      // navigation bar page
            GetPage(
        name: AppRoutes.navigationPage,
        page: () => const NavigationPage(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      // Home route with fade transition
      GetPage(
        name: AppRoutes.home,
        page: () => const HomePage(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),

      // Doctor detail with slide transition
      GetPage(
        name: AppRoutes.doctorDetail,
        page: () => const DoctorDetailPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),

      // Appointment with bottom to top transition
      GetPage(
        name: AppRoutes.appointment,
        page: () => _buildPlaceholderPage('Appointment'),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),

      // My Doctors with cupertino transition
      GetPage(
        name: AppRoutes.myDoctors,
        page: () => _buildPlaceholderPage('My Doctors'),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      // Profile with fade transition
      GetPage(
        name: AppRoutes.profile,
        page: () => _buildPlaceholderPage('Profile'),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      // Auth routes
      GetPage(
        name: AppRoutes.login,
        page: () => _buildPlaceholderPage('Login'),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
      ),

      GetPage(
        name: AppRoutes.register,
        page: () => _buildPlaceholderPage('Register'),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      GetPage(
        name: AppRoutes.forgotPassword,
        page: () => _buildPlaceholderPage('Forgot Password'),
        transition: Transition.zoom,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      // Onboarding routes
      GetPage(
        name: AppRoutes.splash,
        page: () => _buildPlaceholderPage('Splash'),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),

      GetPage(
        name: AppRoutes.onboarding,
        page: () => _buildPlaceholderPage('Onboarding'),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ];
  }

  /// Build placeholder page for routes without implementation
  static Widget _buildPlaceholderPage(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
