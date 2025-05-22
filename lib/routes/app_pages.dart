// lib/routes/app_pages.dart
import 'package:expense_tracker_app/features/auth/binding/auth_binding.dart';
import 'package:expense_tracker_app/features/auth/middleware/auth_middleware.dart';
import 'package:expense_tracker_app/features/auth/page/auth_page.dart';
import 'package:expense_tracker_app/features/auth/page/forgot_password_page.dart';
import 'package:expense_tracker_app/features/screens/oboarding/imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../features/home/imports.dart';
import '../features/screens/language/imports.dart';
import '../features/screens/offline/imports.dart';
import '../features/screens/pin_code/imports.dart';
import '../features/screens/splash/imports.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    // Splash Screen - No transition (instant)
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),

    // Onboarding - Smooth slide transition
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    // Authentication routes
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const AuthPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const AuthPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.emailVerification,
      page: () => const EmailVerificationPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // PIN Code - Secure fade transition
    GetPage(
      name: AppRoutes.pinCode,
      page: () => const PinCodePage(),
      binding: PinCodeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Protected routes with auth middleware
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.admin,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.transactions,
      page: () => const HomePage(), // Replace with actual transactions page
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const HomePage(), // Replace with actual add transaction page
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.categories,
      page: () => const HomePage(), // Replace with actual categories page
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.reports,
      page: () => const HomePage(), // Replace with actual reports page
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const HomePage(), // Replace with actual settings page
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    // Language Settings - Slide from right (settings style)
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    // Offline Screen - Fade transition (emergency state)
    GetPage(
      name: AppRoutes.offline,
      page: () => const OfflinePage(),
      binding: OfflineBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    ),
  ];

  // Custom transition builders for specific use cases
  static Widget _slideUpTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  static Widget _scaleTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}