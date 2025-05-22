// lib/features/screens/onboarding/_controller.dart
part of 'imports.dart';

class _Controller extends GetxController {
  // Current page index
  final currentPage = 0.obs;

  // Page controller for the PageView
  late PageController pageController;

  // Total number of onboarding pages
  static const int pageCount = 3;

  // Onboarding content
  final List<OnboardingContent> pages = [
    OnboardingContent(
      title: 'Gain total control of your money',
      description: 'Become your own money manager and make every cent count',
      imagePath: 'assets/images/control-board.svg',
      color: Colors.deepPurple,
    ),
    OnboardingContent(
      title: 'Know where your money goes',
      description: 'Track your transaction easily, with categories and financial report',
      imagePath: 'assets/images/money-board.svg',
      color: Colors.deepPurple,
    ),
    OnboardingContent(
      title: 'Planning ahead',
      description: 'Setup your budget for each category so you in control',
      imagePath: 'assets/images/plan-board.svg',
      color: Colors.deepPurple,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
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

  // Mark onboarding as completed and navigate to home
  void completeOnboarding() {
    final storage = GetStorage();
    storage.write(StorageKeys.hasCompletedOnboarding, true);
    Get.offAllNamed(AppRoutes.home);
  }

  // Handle page changed from PageView
  void onPageChanged(int page) {
    currentPage.value = page;
  }
}

// Model class for onboarding content
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