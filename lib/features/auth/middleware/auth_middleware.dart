import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Get auth service
    if (!Get.isRegistered<AuthService>()) {
      return null; // Let the app handle registration
    }

    final authService = Get.find<AuthService>();
    final isAuthenticated = authService.isAuthenticated;

    // Define protected routes
    final protectedRoutes = [
      AppRoutes.home,
      AppRoutes.admin,
      AppRoutes.transactions,
      AppRoutes.addTransaction,
      AppRoutes.categories,
      AppRoutes.reports,
      AppRoutes.settings,
    ];

    // Define public routes (accessible without authentication)
    final publicRoutes = [
      AppRoutes.auth,
      AppRoutes.forgotPassword,
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.offline,
    ];

    // If user is not authenticated and trying to access protected route
    if (!isAuthenticated && protectedRoutes.contains(route)) {
      return const RouteSettings(name: AppRoutes.auth);
    }

    // If user is authenticated and trying to access auth page
    if (isAuthenticated && route == AppRoutes.auth) {
      // Check if email is verified
      final user = authService.currentUser.value;
      if (user != null && !user.isEmailVerified) {
        return const RouteSettings(name: AppRoutes.emailVerification);
      }
      return const RouteSettings(name: AppRoutes.home);
    }

    return null; // Continue with original route
  }
}
