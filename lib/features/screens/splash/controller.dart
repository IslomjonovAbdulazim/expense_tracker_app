part of 'imports.dart';

class _Controller extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> logoAnimation;
  late Animation<double> textAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation
    logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    // Text fade animation
    textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
    ));

    // Overall fade animation
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Slide animation for tagline
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
    ));
  }

  void _startSplashSequence() async {
    // Start animations
    animationController.forward();

    // Wait for animation to complete + small delay
    await Future.delayed(const Duration(milliseconds: 3000));

    // Navigate to appropriate screen
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Check if PIN is set
    final storage = GetStorage();
    final isPinProtected = storage.read('app_pin_code') != null;

    if (isPinProtected) {
      Get.offAllNamed(AppRoutes.pinCode);
    } else {
      final hasToken = TokenService.to.hasToken;
      Get.offAllNamed(hasToken ? AppRoutes.admin : AppRoutes.home);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}