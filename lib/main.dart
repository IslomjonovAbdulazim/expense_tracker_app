import 'package:device_preview/device_preview.dart';
import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/di/service_locator.dart';
import 'routes/app_routes.dart';
import 'utils/services/token_service.dart';
import 'utils/services/theme_service.dart';
import 'utils/themes/app_theme.dart';

Future<void> main() async {
  // Initialize Flutter bindings and configurations
  await _initializeApp();

  // Run the app with DevicePreview for responsive testing
  runApp(
    DevicePreview(
      enabled: kIsWeb,
      data: const DevicePreviewData(isDarkMode: true),
      builder: (context) => const MyApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize local storage
  await GetStorage.init();

  // Setup dependency injection
  await setupServiceLocator();

  // Configure system UI appearance
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get themeController from ServiceLocator
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'ExpenseTracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key, // Add this to fix GlobalKey duplication issue
        initialRoute: _determineInitialRoute(),
        getPages: AppPages.routes,
        defaultTransition: Transition.cupertino,
        builder: _appBuilder,
        // Remove the home parameter as it conflicts with initialRoute
      );
    });
  }

  Widget _appBuilder(BuildContext context, Widget? child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
        boldText: false,
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }

  String _determineInitialRoute() {
    try {
      // Check if PIN is set
      final storage = GetStorage();
      final isPinProtected = storage.read('app_pin_code') != null;

      // Check if TokenService is available
      if (Get.isRegistered<TokenService>()) {
        if (isPinProtected) {
          return AppRoutes.pinCode;
        } else {
          return TokenService.to.hasToken ? AppRoutes.admin : AppRoutes.home;
        }
      } else {
        // Fallback if TokenService isn't registered yet
        return AppRoutes.home;
      }
    } catch (e) {
      print('Error determining initial route: $e');
      // Return a safe default route if there's an error
      return AppRoutes.home;
    }
  }
}