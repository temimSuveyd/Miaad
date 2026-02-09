import 'package:doctorbooking/core/routing/presentation/routes/app_routes.dart';
import 'package:doctorbooking/features/home/presentation/pages/appointment_details_page.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/book_appointment/pages/book_appointment_page.dart';
import 'package:doctorbooking/features/shared/appointments/presentation/reschedule_appointment/pages/reschedule_appointment_page.dart';
import 'package:doctorbooking/features/navigation/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/home/presentation/pages/doctor_detail_page.dart';
import '../../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../features/auth/presentation/pages/register_page.dart';
import '../../../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../../../features/auth/presentation/pages/create_new_password_page.dart';
import '../middlewares/auth_middleware.dart';

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
      // Home route with fade transition - protected
      GetPage(
        name: AppRoutes.home,
        page: () => const HomePage(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        middlewares: [AuthMiddleware()],
      ),

      // Doctor detail with slide transition - protected
      GetPage(
        name: AppRoutes.doctorDetail,
        page: () => const DoctorDetailPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        middlewares: [AuthMiddleware()],
      ),

      // Appointment with bottom to top transition - protected
      GetPage(
        name: AppRoutes.bookApptintment,
        page: () => BookAppointmentPage(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        middlewares: [AuthMiddleware()],
      ),

      // Appointment details with fade transition - protected
      GetPage(
        name: AppRoutes.appointmentDetails,
        page: () => const AppointmentDetailsPage(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        middlewares: [AuthMiddleware()],
      ),

      // Reschedule appointment with slide transition - protected
      GetPage(
        name: AppRoutes.rescheduleAppointment,
        page: () => const RescheduleAppointmentPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        middlewares: [AuthMiddleware()],
      ),

      // My Doctors with cupertino transition - protected
      GetPage(
        name: AppRoutes.myDoctors,
        page: () => _buildPlaceholderPage('My Doctors'),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [AuthMiddleware()],
      ),

      // Profile with fade transition - protected
      GetPage(
        name: AppRoutes.profile,
        page: () => _buildPlaceholderPage('Profile'),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [AuthMiddleware()],
      ),

      // Auth routes with GuestMiddleware (prevents authenticated users from accessing auth pages)
      GetPage(
        name: AppRoutes.login,
        page: () => const LoginPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
        middlewares: [GuestMiddleware()],
      ),

      GetPage(
        name: AppRoutes.register,
        page: () => const RegisterPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [GuestMiddleware()],
      ),

      GetPage(
        name: AppRoutes.otp,
        page: () => const OTPVerificationPage(),
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      GetPage(
        name: AppRoutes.forgotPassword,
        page: () => const ForgotPasswordPage(),
        transition: Transition.zoom,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      GetPage(
        name: AppRoutes.createNewPassword,
        page: () => const CreateNewPasswordPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
      ),

      // Onboarding routes
      GetPage(
        name: AppRoutes.onboarding,
        page: () => const OnboardingPage(),
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
