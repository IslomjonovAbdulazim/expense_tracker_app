// app_pages.dart
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
      // Instant load for splash
      transitionDuration: Duration.zero,
    ),

    // Onboarding - Smooth slide transition
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
      // Modern slide transition
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    // PIN Code - Secure fade transition
    GetPage(
      name: AppRoutes.pinCode,
      page: () => const PinCodePage(),
      binding: PinCodeBinding(),
      transition: Transition.fadeIn,
      // Smooth security transition
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Home - Main app entry with slide up
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      // Fixed: Should be HomeBinding, not PinCodeBinding
      transition: Transition.cupertino,
      // iOS-style smooth transition
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    // Language Settings - Slide from right (settings style)
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
      transition: Transition.rightToLeft,
      // Settings-style transition
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    // Offline Screen - Fade transition (emergency state)
    GetPage(
      name: AppRoutes.offline,
      page: () => const OfflinePage(),
      binding: OfflineBinding(),
      transition: Transition.fade,
      // Subtle for error states
      transitionDuration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    ),

    // Admin route (if you have one)
    GetPage(
      name: AppRoutes.admin,
      page: () => const HomePage(),
      // Or your admin page
      binding: HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
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
