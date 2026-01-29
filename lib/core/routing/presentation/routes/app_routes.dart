/// Application route names
class AppRoutes {
  static const String navigationPage = '/navigationPage';
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String home = '/home';
  static const String doctorDetail = '/doctor-detail';
  static const String appointment = '/appointment';
  static const String bookApptintment = '/bookingApptintment';

  static const String myDoctors = '/my-doctors';
  static const String profile = '/profile';

  // Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Initial route
  static const String initial = onboarding;

  // Private constructor to prevent instantiation
  AppRoutes._();
}
