// lib/features/screens/onboarding/page.dart
part of 'imports.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar with logo and theme toggle
            _buildAppBar(context),

            // PageView for onboarding content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: OnboardingController.pageCount,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Obx(() => _OnboardingPageContent(
                    content: controller.pages[index],
                    pageIndex: index,
                    currentPage: controller.currentPage.value,
                  ));
                },
              ),
            ),

            // Progress indicator dots
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Obx(() => _ProgressDots(
                count: OnboardingController.pageCount,
                currentIndex: controller.currentPage.value,
              )),
            ),

            // Navigation buttons
            Obx(() => _OnboardingNavigation(
              currentPage: controller.currentPage.value,
              pageCount: OnboardingController.pageCount,
              onSkip: controller.skipOnboarding,
              onNext: controller.nextPage,
              onBack: controller.previousPage,
            )),
          ],
        ),
      ),
    );
  }

  // App bar with logo and theme toggle
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App logo
          Image.asset(
            'assets/brand/logo.png',
            height: 40,
          ),

          // Theme toggle
          GetBuilder<ThemeController>(
            builder: (themeController) {
              return IconButton(
                icon: Icon(
                  themeController.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeController.updateTheme(
                    themeController.themeMode == ThemeMode.dark
                        ? AppThemeEnum.light
                        : AppThemeEnum.dark,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}