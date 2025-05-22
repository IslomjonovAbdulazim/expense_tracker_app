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
          AdaptiveLogo(
            height: 40,
          ),

          // Theme toggle with better design
          GetBuilder<ThemeController>(
            builder: (themeController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: IconButton(
                  icon: Icon(themeController.currentThemeIcon),
                  onPressed: () => themeController.cycleTheme(),
                  tooltip: 'Theme: ${themeController.currentThemeName}',
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}