// lib/main.dart
import 'package:device_preview/device_preview.dart';
import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_tracker_app/routes/app_routes.dart';

import 'core/di/service_locator.dart';
import 'core/translations/app_translations.dart';
import 'core/translations/language_controller.dart';
import 'utils/themes/app_theme.dart';
import 'utils/services/theme_service.dart';
import 'utils/helpers/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Configure system UI
    await _configureSystemUI();

    // Initialize core dependencies
    await _initializeCoreDependencies();

    // Setup service locator with all dependencies
    await setupServiceLocator();

    // Run app
    runApp(
      DevicePreview(
        enabled: kIsWeb,
        data: DevicePreviewData(
          isDarkMode: true,
        ),
        builder: (context) => const MyApp(),
      ),
    );

  } catch (e) {
    Logger.error('App initialization failed: $e');
    // Run minimal app in case of error
    runApp(const ErrorApp());
  }
}

Future<void> _configureSystemUI() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
}

Future<void> _initializeCoreDependencies() async {
  // Initialize storage first
  await GetStorage.init();

  // Initialize core controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to system theme changes
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LanguageController>(
          builder: (languageController) {
            return GetMaterialApp(
              title: 'Money Track',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode,
              locale: languageController.currentLanguage,
              translations: AppTranslations(),
              fallbackLocale: const Locale('en', 'US'),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splash,
              getPages: AppPages.routes,
              builder: (context, child) {
                // Listen to system theme changes and update accordingly
                final systemBrightness = MediaQuery.of(context).platformBrightness;
                if (themeController.selectedTheme.value == AppThemeEnum.system) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final newThemeMode = systemBrightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light;
                    if (Get.isDarkMode != (newThemeMode == ThemeMode.dark)) {
                      Get.changeThemeMode(newThemeMode);
                    }
                  });
                }

                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                    boldText: false,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: child ?? const Scaffold(),
                  ),
                );
              },
              unknownRoute: GetPage(
                name: '/notfound',
                page: () => const Scaffold(
                  body: Center(
                    child: Text('Page not found'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Error fallback app
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Track',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              const Text(
                'App failed to initialize',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart the app',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}