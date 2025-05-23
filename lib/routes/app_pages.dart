import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../features/auth/binding/auth_binding.dart';
import '../features/auth/middleware/auth_middleware.dart';
import '../features/auth/page/auth_page.dart';
import '../features/auth/page/email_verification_page.dart';
import '../features/auth/page/forgot_password_page.dart';
import '../features/home/imports.dart';
import '../features/screens/oboarding/imports.dart';
import '../features/screens/offline/imports.dart';
import '../features/screens/pin_code/imports.dart';
import '../features/screens/splash/imports.dart';
import '../features/setup/currency_setup/imports.dart';
import '../features/setup/language_setup/imports.dart';
import '../features/setup/theme_setup/imports.dart';
import '../utils/constants/app_constants.dart'; // Import for DevConstants
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

    // Setup/Preference routes (NEW - before onboarding)
    GetPage(
      name: AppRoutes.languageSetup,
      page: () => const LanguageSetupPage(),
      binding: LanguageSetupBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.themeSetup,
      page: () => const ThemeSetupPage(),
      binding: ThemeSetupBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.currencySetup,
      page: () => const CurrencySetupPage(),
      binding: CurrencySetupBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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

    // Protected routes with conditional auth middleware
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.admin,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.transactions,
      page: () => const HomePage(),
      // Replace with actual transactions page
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const HomePage(),
      // Replace with actual add transaction page
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.categories,
      page: () => const HomePage(),
      // Replace with actual categories page
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.reports,
      page: () => const HomePage(),
      // Replace with actual reports page
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const HomePage(),
      // Replace with actual settings page
      binding: HomeBinding(),
      middlewares: DevConstants.enableAuthMiddleware ? [AuthMiddleware()] : [],
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
}
