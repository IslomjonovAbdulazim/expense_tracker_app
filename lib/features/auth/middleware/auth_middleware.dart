// lib/features/auth/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/services/auth_service.dart';
import '../../../utils/helpers/logger.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      Logger.log('AuthMiddleware: Checking route: $route');

      // Get auth service with null safety
      if (!Get.isRegistered<AuthService>()) {
        Logger.warning('AuthService not registered, allowing route: $route');
        return null; // Let the app handle registration
      }

      final authService = Get.find<AuthService>();
      final isAuthenticated = authService.isAuthenticated;

      Logger.log('AuthMiddleware: User authenticated: $isAuthenticated');

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
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.emailVerification,
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.offline,
        AppRoutes.pinCode,
        AppRoutes.language,
      ];

      // If user is not authenticated and trying to access protected route
      if (!isAuthenticated && protectedRoutes.contains(route)) {
        Logger.log('AuthMiddleware: Redirecting to auth page from: $route');
        return const RouteSettings(name: AppRoutes.auth);
      }

      // If user is authenticated and trying to access auth page
      if (isAuthenticated && (route == AppRoutes.auth || route == AppRoutes.login || route == AppRoutes.register)) {
        // Check if email is verified
        final user = authService.currentUser.value;
        if (user != null && !user.isEmailVerified) {
          Logger.log('AuthMiddleware: User not verified, redirecting to email verification');
          return const RouteSettings(name: AppRoutes.emailVerification);
        }
        Logger.log('AuthMiddleware: User authenticated, redirecting to home from: $route');
        return const RouteSettings(name: AppRoutes.home);
      }

      Logger.log('AuthMiddleware: Allowing route: $route');
      return null; // Continue with original route
    } catch (e) {
      Logger.error('AuthMiddleware error: $e');
      // In case of error, allow the route to proceed
      return null;
    }
  }
}