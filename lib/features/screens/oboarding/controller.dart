// Enhanced onboarding controller with better integration
// Update the existing controller in lib/features/screens/onboarding/controller.dart

part of 'imports.dart';

class OnboardingController extends GetxController {
  // Current page index
  final currentPage = 0.obs;

  // Page controller for the PageView
  late PageController pageController;

  // Total number of onboarding pages
  static const int pageCount = 4; // Increased to 4 pages

  // Track if user came from setup flow
  final RxBool fromSetupFlow = false.obs;

  // Onboarding content with updated messaging
  final List<OnboardingContent> pages = [
    OnboardingContent(
      title: 'Welcome to Money Track!',
      description: 'You\'re all set up! Now let\'s show you how to make the most of your expense tracking journey.',
      imagePath: 'assets/images/welcome-board.svg',
      color: Colors.deepPurple,
    ),
    OnboardingContent(
      title: 'Gain total control of your money',
      description: 'With your preferred currency and settings, become your own money manager and make every cent count.',
      imagePath: 'assets/images/control-board.svg',
      color: Colors.deepPurple,
    ),
    OnboardingContent(
      title: 'Know where your money goes',
      description: 'Track your transactions easily with categories and financial reports in your chosen language.',
      imagePath: 'assets/images/money-board.svg',
      color: Colors.deepPurple,
    ),
    OnboardingContent(
      title: 'Start your journey',
      description: 'Everything is configured perfectly for you. Let\'s begin tracking your expenses!',
      imagePath: 'assets/images/start-board.svg',
      color: Colors.deepPurple,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);

    // Check if user came from setup flow
    _checkSetupFlow();
  }

  void _checkSetupFlow() {
    final storage = GetStorage();
    final hasCompletedPreferences = storage.read(StorageKeys.hasCompletedPreferences) ?? false;
    fromSetupFlow.value = hasCompletedPreferences;

    Logger.log('OnboardingController: From setup flow: ${fromSetupFlow.value}');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Navigate to the next page
  void nextPage() {
    if (currentPage.value < pageCount - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // On last page, complete onboarding
      completeOnboarding();
    }
  }

  // Navigate to the previous page
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  // Skip onboarding
  void skipOnboarding() {
    completeOnboarding();
  }

  // Mark onboarding as completed and navigate appropriately
  void completeOnboarding() async {
    try {
      final storage = GetStorage();

      // Mark onboarding as completed
      await storage.write(StorageKeys.hasCompletedOnboarding, true);

      // If preferences weren't completed in setup flow, mark them too
      if (!fromSetupFlow.value) {
        await storage.write(StorageKeys.hasCompletedPreferences, true);
      }

      Logger.success('OnboardingController: Onboarding completed');

      // Navigate to appropriate next screen
      _navigateAfterOnboarding();
    } catch (e) {
      Logger.error('OnboardingController: Error completing onboarding: $e');
      // Still navigate even if storage fails
      _navigateAfterOnboarding();
    }
  }

  void _navigateAfterOnboarding() {
    final storage = GetStorage();

    // Check if PIN is enabled
    final isPinProtected = storage.read(StorageKeys.pinProtected) ?? false;

    if (isPinProtected) {
      Logger.log('OnboardingController: Navigating to PIN setup/entry');
      Get.offAllNamed(AppRoutes.pinCode);
    } else {
      Logger.log('OnboardingController: Navigating to auth');
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  // Handle page changed from PageView
  void onPageChanged(int page) {
    currentPage.value = page;
  }

  // Quick setup option for users who want to skip individual setup
  void showQuickSetup() {
    Get.dialog(
      AlertDialog(
        title: const Text('Quick Setup'),
        content: const Text(
          'Would you like to quickly configure your preferences? '
              'You can always change these later in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              completeOnboarding();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.languageSetup);
            },
            child: const Text('Quick Setup'),
          ),
        ],
      ),
    );
  }

  // Get welcome message based on setup completion
  String get welcomeMessage {
    if (fromSetupFlow.value) {
      return 'Great! You\'ve completed the initial setup.';
    } else {
      return 'Welcome to Money Track! Let\'s get you started.';
    }
  }

  // Get appropriate button text for current state
  String get primaryButtonText {
    if (currentPage.value == pageCount - 1) {
      return fromSetupFlow.value ? 'Start Tracking' : 'Get Started';
    }
    return 'Next';
  }

  // Show setup summary if user completed setup flow
  Map<String, String> getSetupSummary() {
    try {
      final languageController = Get.find<LanguageController>();
      final themeController = Get.find<ThemeController>();
      final currencyService = Get.find<CurrencyService>();

      return {
        'Language': languageController.getLanguageName(),
        'Theme': themeController.currentThemeName,
        'Currency': '${currencyService.currentCurrencyName} (${currencyService.currentCurrencyCode})',
      };
    } catch (e) {
      Logger.warning('OnboardingController: Could not get setup summary: $e');
      return {};
    }
  }
}

// Model class for onboarding content (unchanged)
class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}