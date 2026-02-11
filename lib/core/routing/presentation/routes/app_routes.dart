/// Application route names
class AppRoutes {
  static const String navigationPage = '/navigationPage';
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String createNewPassword = '/create-new-password';

  // Main routes
  static const String home = '/home';
  static const String doctorDetail = '/doctor-detail';
  static const String appointment = '/appointment';
  static const String appointmentDetails = '/appointment-details';
  static const String bookApptintment = '/bookingApptintment';
  static const String rescheduleAppointment = '/reschedule-appointment';

  static const String myDoctors = '/my-doctors';
  static const String profile = '/profile';  
  static const String editAccountPage = '/edit-account-page';

  // Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Initial route
  static const String initial = login;

  // Private constructor to prevent instantiation
  AppRoutes._();
}
