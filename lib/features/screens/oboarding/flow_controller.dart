// lib/features/screens/onboarding/flow_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/helpers/logger.dart';

class OnboardingFlowController extends GetxController {
  final _storage = GetStorage();

  // Track onboarding progress
  final RxInt currentStep = 0.obs;
  final RxBool isCompletingFlow = false.obs;

  // Steps in the onboarding flow
  static const List<String> onboardingSteps = [
    AppRoutes.languageSetup,
    AppRoutes.themeSetup,
    AppRoutes.currencySetup,
    AppRoutes.onboarding, // Visual onboarding
  ];

  @override
  void onInit() {
    super.onInit();
    _checkOnboardingProgress();
  }

  void _checkOnboardingProgress() {
    // Check if user has completed preferences setup
    final hasCompletedPreferences = _storage.read(StorageKeys.hasCompletedPreferences) ?? false;
    final hasCompletedOnboarding = _storage.read(StorageKeys.hasCompletedOnboarding) ?? false;

    Logger.log('OnboardingFlow: Preferences completed: $hasCompletedPreferences');
    Logger.log('OnboardingFlow: Onboarding completed: $hasCompletedOnboarding');

    if (hasCompletedOnboarding) {
      // Skip entire flow
      currentStep.value = onboardingSteps.length;
    } else if (hasCompletedPreferences) {
      // Skip to visual onboarding
      currentStep.value = 3;
    } else {
      // Start from beginning
      currentStep.value = 0;
    }
  }

  Future<void> startOnboardingFlow() async {
    if (currentStep.value >= onboardingSteps.length) {
      // Already completed
      Get.offAllNamed(AppRoutes.auth);
      return;
    }

    final nextRoute = onboardingSteps[currentStep.value];
    Logger.log('OnboardingFlow: Starting with route: $nextRoute');
    Get.offAllNamed(nextRoute);
  }

  Future<void> moveToNextStep() async {
    currentStep.value++;

    if (currentStep.value >= onboardingSteps.length) {
      // Flow completed
      await _completeOnboardingFlow();
      return;
    }

    final nextRoute = onboardingSteps[currentStep.value];
    Logger.log('OnboardingFlow: Moving to step ${currentStep.value}: $nextRoute');
    Get.offAllNamed(nextRoute);
  }

  Future<void> skipToEnd() async {
    currentStep.value = onboardingSteps.length;
    await _completeOnboardingFlow();
  }

  Future<void> _completeOnboardingFlow() async {
    try {
      isCompletingFlow.value = true;

      // Mark both preferences and onboarding as completed
      await _storage.write(StorageKeys.hasCompletedPreferences, true);
      await _storage.write(StorageKeys.hasCompletedOnboarding, true);

      Logger.success('OnboardingFlow: Flow completed successfully');

      // Navigate to auth or main app
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Logger.error('OnboardingFlow: Error completing flow: $e');
    } finally {
      isCompletingFlow.value = false;
    }
  }

  // Helper methods
  double get progressPercentage {
    if (onboardingSteps.isEmpty) return 1.0;
    return (currentStep.value / onboardingSteps.length).clamp(0.0, 1.0);
  }

  String get currentStepName {
    if (currentStep.value >= onboardingSteps.length) {
      return 'Completed';
    }

    switch (onboardingSteps[currentStep.value]) {
      case AppRoutes.languageSetup:
        return 'Language';
      case AppRoutes.themeSetup:
        return 'Theme';
      case AppRoutes.currencySetup:
        return 'Currency';
      case AppRoutes.onboarding:
        return 'Welcome';
      default:
        return 'Setup';
    }
  }

  bool get isLastStep => currentStep.value >= onboardingSteps.length - 1;
  bool get isFirstStep => currentStep.value <= 0;
}