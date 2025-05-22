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
      // Core services (these should already be registered from main.dart)
      _ensureCoreServices();

      // Additional services that might not be registered yet
      _registerAdditionalServices();

      Logger.success('InitialBinding: All dependencies registered successfully');
    } catch (e) {
      Logger.error('InitialBinding: Error registering dependencies: $e');
    }
  }

  void _ensureCoreServices() {
    // Ensure ThemeController is initialized
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
      Logger.log('InitialBinding: ThemeController registered');
    }

    // Ensure LanguageController is initialized
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController(), permanent: true);
      Logger.log('InitialBinding: LanguageController registered');
    }

    // Ensure TokenService is initialized
    if (!Get.isRegistered<TokenService>()) {
      Get.put(TokenService(), permanent: true);
      Logger.log('InitialBinding: TokenService registered');
    }

    // Ensure NetworkService is initialized
    if (!Get.isRegistered<NetworkService>()) {
      final networkService = NetworkService();
      Get.put(networkService, permanent: true);
      Logger.log('InitialBinding: NetworkService registered');
    }
  }

  void _registerAdditionalServices() {
    // Register AuthService if not already done
    if (!Get.isRegistered<AuthService>()) {
      final authService = AuthService();
      Get.put(authService, permanent: true);
      Logger.log('InitialBinding: AuthService registered');
    }

    // Register ConnectivityService if not already done
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put(ConnectivityService(), permanent: true);
      Logger.log('InitialBinding: ConnectivityService registered');
    }

    // Initialize PIN service if available
    /*
    if (!Get.isRegistered<EnhancedPinService>()) {
      try {
        final pinService = EnhancedPinService();
        Get.put(pinService, permanent: true);
        Logger.log('InitialBinding: EnhancedPinService registered');
      } catch (e) {
        Logger.warning('InitialBinding: Failed to register EnhancedPinService: $e');
      }
    }
    */
  }
}