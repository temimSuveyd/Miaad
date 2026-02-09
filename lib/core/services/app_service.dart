import 'package:get/get.dart';
import '../routing/presentation/routes/app_routes.dart';
import 'secure_storage_service.dart';

class AppService extends GetxService {
  static AppService get to => Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkAuthenticationAndRedirect();
  }

  Future<void> _checkAuthenticationAndRedirect() async {
    // Check if user is logged in
    final isLoggedIn = await SecureStorageService.isUserLoggedIn();
    
    if (isLoggedIn) {
      // User is logged in, navigate to home page
      Get.offAllNamed(AppRoutes.navigationPage);
    } else {
      // User is not logged in, navigate to login page
      Get.offAllNamed(AppRoutes.login);
    }
  }

  // Check if user is authenticated (for middleware usage)
  Future<bool> isAuthenticated() async {
    return await SecureStorageService.isUserLoggedIn();
  }
}
