// lib/features/screens/splash/controller.dart
part of 'imports.dart';

class SplashController extends GetxController {
  final RxBool isInitialized = false.obs;
  final RxString initializationMessage = 'Initializing...'.obs;
  final RxDouble progress = 0.0.obs;

  bool _isDisposed = false;
  Timer? _progressTimer;

  @override
  void onInit() {
    super.onInit();
    _startInitializationSequence();
  }

  void _startInitializationSequence() {
    if (_isDisposed) return;

    // Start progress animation
    _startProgressAnimation();

    // Start actual initialization
    _performInitialization();
  }

  void _startProgressAnimation() {
    if (_isDisposed) return;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (progress.value < 1.0) {
        progress.value += 0.02; // Increment progress
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _performInitialization() async {
    if (_isDisposed) return;

    try {
      // Phase 1: Initialize services
      await _initializeServices();
      if (_isDisposed) return;

      // Phase 2: Verify services
      await _verifyServices();
      if (_isDisposed) return;

      // Phase 3: Wait for minimum splash time
      await _waitForMinimumDuration();
      if (_isDisposed) return;

      // Phase 4: Navigate to next screen
      await _navigateToNextScreen();

    } catch (e) {
      Logger.error('Splash initialization failed: $e');
      if (!_isDisposed) {
        _handleInitializationError(e);
      }
    }
  }

  Future<void> _initializeServices() async {
    if (_isDisposed) return;

    initializationMessage.value = 'Loading services...';

    // Simulate service initialization
    await Future.delayed(const Duration(milliseconds: 800));

    if (_isDisposed) return;

    initializationMessage.value = 'Checking configuration...';

    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _verifyServices() async {
    if (_isDisposed) return;

    initializationMessage.value = 'Almost ready...';

    await Future.delayed(const Duration(milliseconds: 400));

    if (_isDisposed) return;

    isInitialized.value = true;
    initializationMessage.value = 'Ready!';
  }

  Future<void> _waitForMinimumDuration() async {
    if (_isDisposed) return;

    // Ensure splash is shown for at least 2 seconds total
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _navigateToNextScreen() async {
    if (_isDisposed) return;

    try {
      final storage = GetStorage();

      // Check if onboarding was completed
      final hasCompletedOnboarding = storage.read(StorageKeys.hasCompletedOnboarding) ?? false;

      if (!hasCompletedOnboarding) {
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      // Check if PIN is required
      final isPinProtected = storage.read(StorageKeys.pinProtected) ?? false;

      if (isPinProtected) {
        Get.offAllNamed(AppRoutes.pinCode);
        return;
      }

      // Check authentication status
      final hasToken = Get.isRegistered<TokenService>() ?
      TokenService.to.hasToken : false;

      // Navigate to appropriate main screen
      if (hasToken) {
        Get.offAllNamed(AppRoutes.admin);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }

    } catch (e) {
      Logger.error('Navigation error: $e');
      // Fallback to home screen
      if (!_isDisposed) {
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  void _handleInitializationError(dynamic error) {
    if (_isDisposed) return;

    initializationMessage.value = 'Something went wrong...';

    // Navigate to home after error
    Timer(const Duration(seconds: 2), () {
      if (!_isDisposed) {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  @override
  void onClose() {
    _isDisposed = true;

    // Cancel progress timer
    _progressTimer?.cancel();
    _progressTimer = null;

    super.onClose();
  }
}