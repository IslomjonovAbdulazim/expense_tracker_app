// lib/features/screens/splash/controller.dart
part of 'imports.dart';

class SplashController extends GetxController {
  final RxBool isInitialized = false.obs;
  final RxString initializationMessage = 'Welcome'.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool showLogo = false.obs;
  final RxBool showTitle = false.obs;
  final RxBool showTagline = false.obs;
  final RxBool showProgress = false.obs;

  bool _isDisposed = false;
  Timer? _progressTimer;
  Timer? _animationTimer;

  @override
  void onInit() {
    super.onInit();
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    if (_isDisposed) return;

    // Staggered animation sequence
    Timer(const Duration(milliseconds: 200), () {
      if (!_isDisposed) showLogo.value = true;
    });

    Timer(const Duration(milliseconds: 800), () {
      if (!_isDisposed) {
        showTitle.value = true;
        initializationMessage.value = 'Money Track';
      }
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!_isDisposed) {
        showTagline.value = true;
        initializationMessage.value = 'Loading services...';
      }
    });

    Timer(const Duration(milliseconds: 1600), () {
      if (!_isDisposed) {
        showProgress.value = true;
        _startProgressAnimation();
        _performInitialization();
      }
    });
  }

  void _startProgressAnimation() {
    if (_isDisposed) return;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (progress.value < 1.0) {
        progress.value += 0.008; // Slower, smoother progress
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

      // Phase 3: Final preparations
      await _finalizeInitialization();
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
    await Future.delayed(const Duration(milliseconds: 1000));

    if (_isDisposed) return;

    initializationMessage.value = 'Configuring app...';
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _verifyServices() async {
    if (_isDisposed) return;

    initializationMessage.value = 'Verifying setup...';
    await Future.delayed(const Duration(milliseconds: 600));

    if (_isDisposed) return;

    initializationMessage.value = 'Almost ready...';
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _finalizeInitialization() async {
    if (_isDisposed) return;

    isInitialized.value = true;
    initializationMessage.value = 'Welcome!';
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
      if (!_isDisposed) {
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  void _handleInitializationError(dynamic error) {
    if (_isDisposed) return;

    initializationMessage.value = 'Something went wrong...';

    Timer(const Duration(seconds: 2), () {
      if (!_isDisposed) {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  @override
  void onClose() {
    _isDisposed = true;
    _progressTimer?.cancel();
    _animationTimer?.cancel();
    _progressTimer = null;
    _animationTimer = null;
    super.onClose();
  }
}