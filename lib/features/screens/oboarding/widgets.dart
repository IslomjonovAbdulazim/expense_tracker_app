part of 'imports.dart';

class _OnboardingPageContent extends StatelessWidget {
  final OnboardingContent content;
  final int pageIndex;
  final int currentPage;

  const _OnboardingPageContent({
    required this.content,
    required this.pageIndex,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on whether this is the current page
    final isCurrentPage = pageIndex == currentPage;
    final opacity = isCurrentPage ? 1.0 : 0.6;

    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG illustration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SvgPicture.asset(
              content.imagePath,
              height: Get.height * 0.28,
              width: Get.width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: Get.height * 0.08),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              content.title,
              style: context.headingMedium.copyWith(
                color: content.color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              content.description,
              style: context.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Progress indicator dots
class _ProgressDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _ProgressDots({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: index == currentIndex ? 24 : 8,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

// Navigation buttons at the bottom
class _OnboardingNavigation extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _OnboardingNavigation({
    required this.currentPage,
    required this.pageCount,
    required this.onSkip,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == pageCount - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back or Skip button
          if (currentPage > 0)
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                textStyle: context.labelLarge,
              ),
            )
          else
            TextButton(
              onPressed: onSkip,
              child: const Text('Skip'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                textStyle: context.labelLarge,
              ),
            ),

          // Next or Get Started button
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: context.labelLarge,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLastPage ? 'Get Started' : 'Next'),
                const SizedBox(width: 8),
                Icon(
                  isLastPage ? Icons.check_circle : Icons.arrow_forward,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}