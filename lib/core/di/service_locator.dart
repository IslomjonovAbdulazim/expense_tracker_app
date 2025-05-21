// lib/core/di/service_locator.dart
import 'package:get/get.dart';

import '../../data/providers/dio_manager.dart';  // Make sure this import exists
import '../../utils/services/connectivity_service.dart';
import '../../utils/services/pin_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/services/theme_service.dart';

Future<void> setupServiceLocator() async {
  try {
    // Initialize network first
    // Make sure configureDio is imported from dio_manager.dart
    configureDio();

    // Initialize dependencies in the correct order
    if (!Get.isRegistered<TokenService>()) {
      await Get.putAsync<TokenService>(() async => await TokenService().init(), permanent: true);
    }

    if (!Get.isRegistered<PinService>()) {
      await Get.putAsync<PinService>(() async => await PinService().init(), permanent: true);
    }

    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }

    // Initialize connectivity service last with a delay to ensure other services are ready
    await Future.delayed(const Duration(milliseconds: 300));

    if (!Get.isRegistered<ConnectivityService>()) {
      await Get.putAsync<ConnectivityService>(() async => await ConnectivityService().init(), permanent: true);
    }
  } catch (e) {
    print('Error in service locator setup: $e');
    // Initialize minimal services to keep app functional
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }
  }
}