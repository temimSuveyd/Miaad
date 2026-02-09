import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../../../services/app_service.dart';

/// Middleware to prevent authenticated users from accessing auth pages
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is authenticated synchronously using AppService
    _checkAuthAndRedirect(route);
    return null;
  }

  Future<void> _checkAuthAndRedirect(String? route) async {
    // Small delay to allow the middleware to complete
    await Future.delayed(const Duration(milliseconds: 100));
    
    final isLoggedIn = await AppService.to.isAuthenticated();
    
    if (isLoggedIn && (route == AppRoutes.login || route == AppRoutes.register)) {
      // Redirect to home if already authenticated
      Get.offAllNamed(AppRoutes.navigationPage);
    }
  }
}

/// Middleware to check authentication before accessing protected routes
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is authenticated synchronously using AppService
    _checkAuthAndRedirect(route);
    return null;
  }

  Future<void> _checkAuthAndRedirect(String? route) async {
    // Small delay to allow the middleware to complete
    await Future.delayed(const Duration(milliseconds: 100));
    
    final isLoggedIn = await AppService.to.isAuthenticated();
    
    if (!isLoggedIn && route != AppRoutes.login) {
      // Redirect to login if not authenticated
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
