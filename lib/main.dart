// lib/main.dart - Update initial route
import 'package:device_preview/device_preview.dart';
import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_tracker_app/routes/app_routes.dart';

import 'core/di/initial_binding.dart';
import 'utils/services/theme_service.dart';
import 'utils/services/token_service.dart' show TokenService;
import 'utils/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  await Get.putAsync<TokenService>(() async => await TokenService().init());
  Get.put(ThemeController());
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  runApp(
    DevicePreview(
      enabled: kIsWeb,
      data: DevicePreviewData(
        isDarkMode: true,
      ),
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Money Track',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash, // Start with splash screen
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
}