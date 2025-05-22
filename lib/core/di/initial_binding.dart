// lib/setup/initial_binding.dart
import 'package:get/get.dart';

import '../../utils/services/connectivity_service.dart';
import '../network/network_service.dart';
import '../../utils/services/pin_service.dart';
import '../../utils/services/theme_service.dart';
import '../translations/language_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    // Ensure ThemeController is initialized
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController());
    }

    // Initialize PIN service if not already done
    if (!Get.isRegistered<EnhancedPinService>()) {
      await Get.putAsync<EnhancedPinService>(() async => EnhancedPinService());
    }


    // Initialize connectivity service
    Get.put(ConnectivityService());

    // Initialize network service (singleton)
    // It's already initialized through its constructor, but we ensure it here
    NetworkService().initialize();
  }
}