import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:expense_tracker_app/utils/constants/app_constants.dart';
import 'package:expense_tracker_app/utils/services/pin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/di/initial_binding.dart';
import 'core/translations/language_controller.dart';
import 'routes/app_routes.dart';
import 'utils/services/theme_service.dart';
import 'utils/services/token_service.dart';
import 'utils/themes/app_theme.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize local storage
  await GetStorage.init();

  // For SSL certificate bypass in development (if needed)
  // HttpOverrides.global = MyHttpOverrides();

  // Initialize services
  await Get.putAsync<TokenService>(() async => await TokenService().init());
  Get.put(ThemeController());
  Get.put(PinService());

  // Initialize system UI settings
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  await Get.putAsync<LanguageController>(() async => LanguageController());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'ExpenseTracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeController.to.themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: _determineInitialRoute(),
        initialBinding: InitialBinding(),
        getPages: AppPages.routes,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
            boldText: false,
          ),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: child ?? const Scaffold(),
          ),
        ),
      );
    });
  }

  // In lib/main.dart

  String _determineInitialRoute() {
    final pinService = Get.find<PinService>();
    final storage = GetStorage();

    // Check if the app has completed onboarding
    final hasCompletedOnboarding = storage.read(StorageKeys.hasCompletedOnboarding) ?? false;
    if (!hasCompletedOnboarding) {
      // todo return AppRoutes.onboarding; // First-time user goes to onboarding
    }

    // Check if PIN protection is enabled
    if (pinService.isPinEnabled()) {
      // PIN is set, check if already authenticated in this session
      if (pinService.isAuthenticated.value) {
        return AppRoutes.home; // Already authenticated, go to home
      } else {
        return AppRoutes.pinCode; // PIN set but not authenticated, go to PIN entry
      }
    } else {
      // No PIN protection, go directly to home
      return AppRoutes.pinCode;
    }
  }
}