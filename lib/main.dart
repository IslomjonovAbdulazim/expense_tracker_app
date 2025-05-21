import 'package:expense_tracker_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/di/service_locator.dart';
import 'core/translations/translation_service.dart';
import 'utils/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await GetStorage.init();

  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TranslationService translationService = Get.put(TranslationService());
    return GetMaterialApp.router(
      title: 'Expense',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      translations: translationService,
      locale: translationService.getSavedLanguage(),
      fallbackLocale: TranslationService.fallbackLocale,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      defaultTransition: Transition.native,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
            boldText: false,
          ),
          child: child,
        );
      },
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {}
}
