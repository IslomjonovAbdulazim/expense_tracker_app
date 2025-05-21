import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/di/initial_binding.dart';
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

  // Initialize system UI settings
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'ExpenseTracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
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

  String _determineInitialRoute() {
    // Check if PIN is set
    final storage = GetStorage();
    final isPinProtected = storage.read('app_pin_code') != null;

    if (isPinProtected) {
      return AppRoutes.pinCode;
    } else {
      return AppRoutes.language;
    }
  }
}