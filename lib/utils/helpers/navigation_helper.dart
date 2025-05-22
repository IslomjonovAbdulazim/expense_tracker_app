// lib/utils/helpers/setup_navigation_helper.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/helpers/logger.dart';

class SetupNavigationHelper {
  static final _storage = GetStorage();

  // Define the setup flow order
  static const List<String> setupFlow = [
    AppRoutes.languageSetup,
    AppRoutes.themeSetup,
    AppRoutes.currencySetup,
  ];

  /// Navigate to the next step in the setup flow
  static Future<void> navigateToNextSetupStep(String currentRoute) async {
    final currentIndex = setupFlow.indexOf(currentRoute);

    if (currentIndex == -1) {
      Logger.error('SetupNavigationHelper: Unknown route: $currentRoute');
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // Check if this is the last step
    if (currentIndex >= setupFlow.length - 1) {
      // Completed all setup steps
      await _completeSetupFlow();
      return;
    }

    // Navigate to next setup step
    final nextRoute = setupFlow[currentIndex + 1];
    Logger.log('SetupNavigationHelper: Navigating from $currentRoute to $nextRoute');
    Get.offAllNamed(nextRoute);
  }

  /// Skip the current setup step and go to next
  static Future<void> skipCurrentStep(String currentRoute) async {
    await navigateToNextSetupStep(currentRoute);
  }

  /// Complete the entire setup flow
  static Future<void> _completeSetupFlow() async {
    try {
      // Mark preferences as completed
      await _storage.write(StorageKeys.hasCompletedPreferences, true);

      Logger.success('SetupNavigationHelper: Setup flow completed');

      // Navigate to visual onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      Logger.error('SetupNavigationHelper: Error completing setup flow: $e');
      // Navigate anyway
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  /// Navigate to a specific setup step (for settings)
  static void navigateToSetupStep(String route, {bool fromSettings = false}) {
    final arguments = fromSettings ? {'fromSettings': true} : null;
    Get.toNamed(route, arguments: arguments);
  }

  /// Get the progress of setup flow
  static double getSetupProgress(String currentRoute) {
    final currentIndex = setupFlow.indexOf(currentRoute);
    if (currentIndex == -1) return 0.0;

    return (currentIndex + 1) / setupFlow.length;
  }

  /// Get the step number for current route
  static int getStepNumber(String currentRoute) {
    final currentIndex = setupFlow.indexOf(currentRoute);
    return currentIndex + 1;
  }

  /// Get total number of setup steps
  static int get totalSteps => setupFlow.length;

  /// Check if user has completed setup flow
  static bool hasCompletedSetup() {
    return _storage.read(StorageKeys.hasCompletedPreferences) ?? false;
  }

  /// Reset setup flow (for testing or re-onboarding)
  static Future<void> resetSetupFlow() async {
    try {
      await _storage.remove(StorageKeys.hasCompletedPreferences);
      await _storage.remove(StorageKeys.hasCompletedOnboarding);
      Logger.log('SetupNavigationHelper: Setup flow reset');
    } catch (e) {
      Logger.error('SetupNavigationHelper: Error resetting setup flow: $e');
    }
  }

  /// Get setup step labels for progress indicator
  static List<String> get stepLabels => [
    'Language',
    'Theme',
    'Currency',
  ];

  /// Navigate from settings to setup flow
  static void navigateToSetupFromSettings(String route) {
    navigateToSetupStep(route, fromSettings: true);
  }
}