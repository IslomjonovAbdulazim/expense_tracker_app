// lib/main.dart
import 'package:device_preview/device_preview.dart';
import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:expense_tracker_app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/di/service_locator.dart';
import 'core/di/initial_binding.dart';
import 'core/translations/app_translations.dart';
import 'core/translations/language_controller.dart';
import 'utils/helpers/app_diagnostics.dart';
import 'utils/helpers/logger.dart';
import 'utils/services/theme_service.dart';
import 'utils/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Logger.log('🚀 Starting app initialization...');

    // Initialize Firebase FIRST (before any Firebase services)
    await _initializeFirebase();

    // Configure system UI
    await _configureSystemUI();
    Logger.log('✅ System UI configured');

    // Initialize core dependencies
    await _initializeCoreDependencies();
    Logger.log('✅ Core dependencies initialized');

    // Run debug initialization check
    await _debugInitialization();

    // Setup service locator with all dependencies
    await setupServiceLocator();
    Logger.log('✅ Service locator setup completed');

    // Log successful initialization
    Logger.success('🎉 App initialization completed successfully');

    // Run app
    runApp(
      DevicePreview(
        enabled: false, // Disabled for now to avoid issues
        data: DevicePreviewData(
          isDarkMode: true,
        ),
        builder: (context) => const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    Logger.error('❌ App initialization failed: $e');
    Logger.error('Stack trace: $stackTrace');

    // Run comprehensive diagnostics if initialization fails
    if (kDebugMode) {
      try {
        final diagnostics = await AppDiagnostics.runDiagnostics();
        final report = AppDiagnostics.formatDiagnostics(diagnostics);
        Logger.log('🔍 Emergency Diagnostics Report:\n$report');
      } catch (diagError) {
        Logger.error('Failed to run emergency diagnostics: $diagError');
      }
    }

    // Run minimal app in case of error
    runApp(ErrorApp(error: e.toString()));
  }
}

Future<void> _initializeFirebase() async {
  try {
    Logger.log('🔥 Initializing Firebase...');

    // Try to initialize Firebase with options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Logger.success('✅ Firebase initialized successfully');
  } catch (e) {
    Logger.error('❌ Firebase initialization failed: $e');

    // Try to initialize without options (fallback)
    try {
      Logger.log('🔥 Trying Firebase initialization without options...');
      await Firebase.initializeApp();
      Logger.success('✅ Firebase initialized successfully (fallback)');
    } catch (fallbackError) {
      Logger.error('❌ Firebase fallback initialization failed: $fallbackError');
      // Don't rethrow - we'll handle this gracefully by disabling Firebase features
      Logger.warning('⚠️ Firebase features will be disabled');
    }
  }
}

Future<void> _configureSystemUI() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  } catch (e) {
    Logger.error('System UI configuration failed: $e');
    // Continue anyway, this isn't critical
  }
}

Future<void> _initializeCoreDependencies() async {
  try {
    Logger.log('📦 Initializing GetStorage...');
    // Initialize storage first
    await GetStorage.init();

    // Test storage immediately
    final storage = GetStorage();
    final testKey = 'main_init_test_${DateTime.now().millisecondsSinceEpoch}';
    await storage.write(testKey, 'test_value');
    final testResult = storage.read(testKey);
    await storage.remove(testKey);

    if (testResult != 'test_value') {
      throw Exception('GetStorage read/write test failed');
    }
    Logger.log('✅ GetStorage working properly');

    Logger.log('🎨 Initializing ThemeController...');
    // Initialize core controllers
    Get.put(ThemeController(), permanent: true);
    Logger.log(
        '✅ ThemeController registered: ${Get.isRegistered<ThemeController>()}');

    Logger.log('🌐 Initializing LanguageController...');
    Get.put(LanguageController(), permanent: true);
    Logger.log(
        '✅ LanguageController registered: ${Get.isRegistered<LanguageController>()}');
  } catch (e) {
    Logger.error('Core dependencies initialization failed: $e');
    rethrow;
  }
}

Future<void> _debugInitialization() async {
  if (!kDebugMode) return;

  Logger.log('🔍 === DEBUG INITIALIZATION CHECK ===');

  try {
    // Check Firebase status
    Logger.log('🔥 Firebase apps: ${Firebase.apps.length}');

    // Check GetStorage functionality
    final storage = GetStorage();
    storage.write('debug_init_test', 'ok');
    final test = storage.read('debug_init_test');
    Logger.log('📦 GetStorage working: ${test == 'ok'}');

    // Check if controllers are properly registered
    Logger.log(
        '🎮 ThemeController registered: ${Get.isRegistered<ThemeController>()}');
    Logger.log(
        '🌐 LanguageController registered: ${Get.isRegistered<LanguageController>()}');

    // Test controller functionality
    if (Get.isRegistered<ThemeController>()) {
      final themeController = Get.find<ThemeController>();
      Logger.log(
          '🎨 ThemeController mode: ${themeController.currentThemeName}');
    }

    if (Get.isRegistered<LanguageController>()) {
      final languageController = Get.find<LanguageController>();
      Logger.log(
          '🗣️ LanguageController locale: ${languageController.currentLanguage}');
    }

    // Check routes configuration
    Logger.log('🛣️ Total routes defined: ${AppPages.routes.length}');
    Logger.log(
        '🛣️ Splash route exists: ${AppPages.routes.any((r) => r.name == AppRoutes.splash)}');
    Logger.log(
        '🛣️ Auth route exists: ${AppPages.routes.any((r) => r.name == AppRoutes.auth)}');
    Logger.log(
        '🛣️ Home route exists: ${AppPages.routes.any((r) => r.name == AppRoutes.home)}');
    Logger.log(
        '🛣️ Onboarding route exists: ${AppPages.routes.any((r) => r.name == AppRoutes.onboarding)}');
    Logger.log(
        '🛣️ Pin code route exists: ${AppPages.routes.any((r) => r.name == AppRoutes.pinCode)}');

    // Check GetX state
    Logger.log('🧭 GetX context available: ${Get.context != null}');
    Logger.log('🧭 Current route: ${Get.currentRoute}');
    Logger.log('🧭 GetX services registered: ${Get.size}');

    // Run quick diagnostics
    await AppDiagnostics.printQuickDiagnostics();
  } catch (e) {
    Logger.error('❌ Debug initialization check failed: $e');
  }

  Logger.log('🔍 === DEBUG INITIALIZATION COMPLETE ===');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.log('🏗️ Building MyApp widget...');

    // Listen to system theme changes
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LanguageController>(
          builder: (languageController) {
            Logger.log(
                '🎨 Building app with theme: ${themeController.currentThemeName}');
            Logger.log(
                '🗣️ Building app with locale: ${languageController.currentLanguage}');

            return GetMaterialApp(
              title: 'Money Track',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode,
              locale: languageController.currentLanguage,
              translations: AppTranslations(),
              fallbackLocale: const Locale('en', 'US'),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.home,
              getPages: AppPages.routes,
              initialBinding: InitialBinding(),

              // Enhanced error handling
              routingCallback: (routing) {
                if (kDebugMode) {
                  Logger.log('🧭 Navigating: ${routing?.current} -> ${routing?.previous}');
                }
              },

              builder: (context, child) {
                // Listen to system theme changes and update accordingly
                final systemBrightness =
                    MediaQuery.of(context).platformBrightness;
                if (themeController.selectedTheme.value ==
                    AppThemeEnum.system) {
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
                    child: child ??
                        const Scaffold(
                          body: Center(
                            child: Text('App Loading...'),
                          ),
                        ),
                  ),
                );
              },

              // Enhanced unknown route handling
              unknownRoute: GetPage(
                name: '/notfound',
                page: () => Scaffold(
                  appBar: AppBar(
                    title: const Text('Page Not Found'),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Page not found',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Get.offAllNamed(AppRoutes.auth),
                          child: const Text('Go to Login'),
                        ),
                        if (kDebugMode) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Current route: ${Get.currentRoute}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
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

// Enhanced error fallback app
class ErrorApp extends StatelessWidget {
  final String? error;

  const ErrorApp({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Track - Error',
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'App failed to initialize',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong during startup.\nPlease restart the app.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (error != null && kDebugMode) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Error Details (Debug Mode):',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Force restart the app
                      SystemNavigator.pop();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}