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

  // Add debugging information
  final RxString debugInfo = ''.obs;
  final RxBool hasError = false.obs;

  bool _isDisposed = false;
  Timer? _progressTimer;
  Timer? _animationTimer;
  Timer? _timeoutTimer;

  // Add timeout for initialization
  static const Duration initializationTimeout = Duration(seconds: 15);

  @override
  void onInit() {
    super.onInit();
    Logger.log('SplashController: onInit called');

    // Run quick diagnostics in debug mode
    if (kDebugMode) {
      AppDiagnostics.printQuickDiagnostics();
    }

    _startTimeoutTimer();
    _startAnimationSequence();
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(initializationTimeout, () {
      if (!_isDisposed && !isInitialized.value) {
        Logger.error('SplashController: Initialization timeout');
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    hasError.value = true;
    initializationMessage.value = 'Taking longer than expected...';
    debugInfo.value = 'Timeout after ${initializationTimeout.inSeconds} seconds';

    // Force navigation after timeout
    Timer(const Duration(seconds: 2), () {
      if (!_isDisposed) {
        Logger.warning('SplashController: Force navigating due to timeout');
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  void _startAnimationSequence() {
    if (_isDisposed) return;
    Logger.log('SplashController: Starting animation sequence');

    // Staggered animation sequence with better timing
    Timer(const Duration(milliseconds: 100), () {
      if (!_isDisposed) {
        Logger.log('SplashController: Showing logo');
        showLogo.value = true;
      }
    });

    Timer(const Duration(milliseconds: 600), () {
      if (!_isDisposed) {
        Logger.log('SplashController: Showing title');
        showTitle.value = true;
        initializationMessage.value = 'Money Track';
      }
    });

    Timer(const Duration(milliseconds: 1000), () {
      if (!_isDisposed) {
        Logger.log('SplashController: Showing tagline');
        showTagline.value = true;
        initializationMessage.value = 'Initializing...';
      }
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!_isDisposed) {
        Logger.log('SplashController: Showing progress and starting initialization');
        showProgress.value = true;
        _startProgressAnimation();
        _performInitialization();
      }
    });
  }

  void _startProgressAnimation() {
    if (_isDisposed) return;
    Logger.log('SplashController: Starting progress animation');

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (progress.value < 0.9) {
        progress.value += 0.01;
      } else if (isInitialized.value) {
        progress.value = 1.0;
        timer.cancel();
      }
    });
  }

  Future<void> _performInitialization() async {
    if (_isDisposed) return;
    Logger.log('SplashController: Starting initialization process');

    try {
      // Phase 1: Basic setup
      await _initializeBasicServices();
      if (_isDisposed) return;

      // Phase 2: Storage and preferences
      await _initializeStorage();
      if (_isDisposed) return;

      // Phase 3: Authentication services
      await _initializeAuthServices();
      if (_isDisposed) return;

      // Phase 4: Network and connectivity
      await _initializeNetworkServices();
      if (_isDisposed) return;

      // Phase 5: Final preparations
      await _finalizeInitialization();
      if (_isDisposed) return;

      // Phase 6: Navigate to appropriate screen
      await _navigateToNextScreen();

    } catch (e) {
      Logger.error('SplashController: Initialization failed: $e');
      if (!_isDisposed) {
        _handleInitializationError(e);
      }
    }
  }

  Future<void> _initializeBasicServices() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Initializing basic services');
    initializationMessage.value = 'Setting up core services...';
    debugInfo.value = 'Core services';

    await Future.delayed(const Duration(milliseconds: 300));

    // Verify GetStorage is initialized
    try {
      final storage = GetStorage();
      final testKey = 'splash_test_${DateTime.now().millisecondsSinceEpoch}';
      await storage.write(testKey, 'test');
      await storage.remove(testKey);
      Logger.success('SplashController: GetStorage verified');
    } catch (e) {
      Logger.error('SplashController: GetStorage error: $e');
      throw Exception('Storage initialization failed');
    }
  }

  Future<void> _initializeStorage() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Initializing storage services');
    initializationMessage.value = 'Loading preferences...';
    debugInfo.value = 'Storage & preferences';

    await Future.delayed(const Duration(milliseconds: 400));

    try {
      // Test SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final testValue = await prefs.getString('test_key');
      Logger.log('SplashController: SharedPreferences working: ${testValue != null}');
    } catch (e) {
      Logger.error('SplashController: SharedPreferences error: $e');
      // Don't throw here, it's not critical
    }
  }

  Future<void> _initializeAuthServices() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Initializing auth services');
    initializationMessage.value = 'Checking security...';
    debugInfo.value = 'Authentication services';

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // Check if TokenService is available
      if (Get.isRegistered<TokenService>()) {
        Logger.log('SplashController: TokenService available');
      } else {
        Logger.warning('SplashController: TokenService not registered');
      }
    } catch (e) {
      Logger.error('SplashController: Auth services error: $e');
      // Continue anyway, auth is not critical for initial app load
    }
  }

  Future<void> _initializeNetworkServices() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Initializing network services');
    initializationMessage.value = 'Connecting...';
    debugInfo.value = 'Network services';

    await Future.delayed(const Duration(milliseconds: 400));

    try {
      // Check network services
      if (Get.isRegistered<ConnectivityService>()) {
        Logger.log('SplashController: ConnectivityService available');
      } else {
        Logger.warning('SplashController: ConnectivityService not registered');
      }
    } catch (e) {
      Logger.error('SplashController: Network services error: $e');
      // Continue anyway, network issues shouldn't block app startup
    }
  }

  Future<void> _finalizeInitialization() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Finalizing initialization');
    initializationMessage.value = 'Almost ready...';
    debugInfo.value = 'Finalizing';

    await Future.delayed(const Duration(milliseconds: 500));

    isInitialized.value = true;
    progress.value = 1.0;
    initializationMessage.value = 'Ready!';

    Logger.success('SplashController: Initialization completed successfully');
  }

  Future<void> _navigateToNextScreen() async {
    if (_isDisposed) return;

    Logger.log('SplashController: Determining navigation target');

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final storage = GetStorage();

      // Check onboarding status
      final hasCompletedOnboarding = storage.read(StorageKeys.hasCompletedOnboarding) ?? false;
      Logger.log('SplashController: Has completed onboarding: $hasCompletedOnboarding');

      if (!hasCompletedOnboarding) {
        Logger.log('SplashController: Navigating to onboarding');
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      // Check PIN requirement
      final isPinProtected = storage.read(StorageKeys.pinProtected) ?? false;
      Logger.log('SplashController: Is PIN protected: $isPinProtected');

      if (isPinProtected) {
        Logger.log('SplashController: Navigating to PIN entry');
        Get.offAllNamed(AppRoutes.pinCode);
        return;
      }

      // Check authentication
      final hasToken = Get.isRegistered<TokenService>() ?
      TokenService.to.hasToken : false;
      Logger.log('SplashController: Has auth token: $hasToken');

      // Navigate to main app
      final targetRoute = hasToken ? AppRoutes.admin : AppRoutes.home;
      Logger.log('SplashController: Navigating to: $targetRoute');
      Get.offAllNamed(targetRoute);

    } catch (e) {
      Logger.error('SplashController: Navigation error: $e');
      if (!_isDisposed) {
        // Fallback navigation
        Logger.warning('SplashController: Using fallback navigation to home');
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  Future<void> _handleInitializationError(dynamic error) async {
    if (_isDisposed) return;

    Logger.error('SplashController: Handling initialization error: $error');

    // Run full diagnostics to help debug the issue
    if (kDebugMode) {
      try {
        final diagnostics = await AppDiagnostics.runDiagnostics();
        final report = AppDiagnostics.formatDiagnostics(diagnostics);
        Logger.log('SplashController: Diagnostics Report:\n$report');
      } catch (e) {
        Logger.error('SplashController: Failed to run diagnostics: $e');
      }
    }

    hasError.value = true;
    initializationMessage.value = 'Something went wrong...';
    debugInfo.value = 'Error: ${error.toString()}';

    // Show error for a moment, then navigate anyway
    Timer(const Duration(seconds: 3), () {
      if (!_isDisposed) {
        Logger.log('SplashController: Navigating despite error');
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  // Add manual skip option for testing
  void skipToHome() {
    Logger.log('SplashController: Manual skip to home');
    if (!_isDisposed) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  @override
  void onClose() {
    Logger.log('SplashController: onClose called');
    _isDisposed = true;
    _progressTimer?.cancel();
    _animationTimer?.cancel();
    _timeoutTimer?.cancel();
    _progressTimer = null;
    _animationTimer = null;
    _timeoutTimer = null;
    super.onClose();
  }
}