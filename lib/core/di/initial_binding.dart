// lib/core/di/initial_binding.dart
import 'package:get/get.dart';

import '../../utils/services/connectivity_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/services/auth_service.dart';
import '../network/network_service.dart';
import '../../utils/services/theme_service.dart';
import '../translations/language_controller.dart';
import '../../utils/helpers/logger.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Logger.log('InitialBinding: Starting dependency registration...');

    try {
      // Register bindings but don't initialize services here
      // Services are initialized in service_locator.dart
      _registerControllers();

      Logger.success('InitialBinding: All bindings registered successfully');
    } catch (e) {
      Logger.error('InitialBinding: Error registering bindings: $e');
    }
  }

  void _registerControllers() {
    // Ensure core controllers are available (these should already be registered)
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
      Logger.log('InitialBinding: ThemeController registered');
    }

    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController(), permanent: true);
      Logger.log('InitialBinding: LanguageController registered');
    }

    // Note: Other services are handled by service_locator.dart
    // We just ensure they're accessible here if needed
    Logger.log('InitialBinding: Core controllers ensured');
  }
}