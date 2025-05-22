// lib/features/screens/splash/page.dart
part of 'imports.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primary.withOpacity(0.05),
                  context.secondary.withOpacity(0.05),
                  context.primary.withOpacity(0.02),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Top spacer
                    const Spacer(flex: 2),

                    // Logo section
                    _buildLogoSection(context),

                    // Middle spacer
                    const Spacer(flex: 1),

                    // App name section
                    _buildAppNameSection(context),

                    // Small spacer
                    const SizedBox(height: 16),

                    // Tagline section
                    _buildTaglineSection(context),

                    // Bottom spacer
                    const Spacer(flex: 2),

                    // Progress section with enhanced debugging
                    _buildProgressSection(context),

                    // Debug section (only in debug mode)
                    if (kDebugMode) _buildDebugSection(context),

                    // Bottom section with theme controls and skip option
                    _buildBottomSection(context, themeController),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Obx(() => AnimatedScale(
      scale: controller.showLogo.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      child: AnimatedOpacity(
        opacity: controller.showLogo.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                context.primary.withOpacity(0.1),
                context.primary.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.primary.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.surface,
                boxShadow: [
                  BoxShadow(
                    color: context.primary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: AdaptiveLogo(
                  width: 60,
                  height: 60,
                  showText: true,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildAppNameSection(BuildContext context) {
    return Obx(() => AnimatedSlide(
      offset: controller.showTitle.value ? Offset.zero : const Offset(0, 0.3),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: controller.showTitle.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        child: AnimatedScale(
          scale: controller.showTitle.value ? 1.0 : 0.8,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          child: Text(
            'Money Track',
            style: context.headingLarge.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              fontSize: 32,
              shadows: [
                Shadow(
                  color: context.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  Widget _buildTaglineSection(BuildContext context) {
    return Obx(() => AnimatedSlide(
      offset: controller.showTagline.value ? Offset.zero : const Offset(0, 0.5),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: controller.showTagline.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1000),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Track your expenses smartly',
            style: context.bodyLarge.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  Widget _buildProgressSection(BuildContext context) {
    return Obx(() => AnimatedSlide(
      offset: controller.showProgress.value ? Offset.zero : const Offset(0, 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: controller.showProgress.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status message with error handling
            SizedBox(
              height: 48, // Increased height for better text visibility
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey(controller.initializationMessage.value),
                  children: [
                    Text(
                      controller.initializationMessage.value,
                      style: context.bodyMedium.copyWith(
                        color: controller.hasError.value
                            ? context.error
                            : context.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (controller.hasError.value) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Tap to continue anyway',
                        style: context.bodySmall.copyWith(
                          color: context.textSecondary,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Progress indicators container
            Container(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Column(
                children: [
                  // Linear progress bar with percentage
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: context.primary.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: controller.progress.value,
                              backgroundColor: context.primary.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  controller.hasError.value
                                      ? context.error
                                      : context.primary
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(controller.progress.value * 100).toInt()}%',
                        style: context.bodySmall.copyWith(
                          color: controller.hasError.value
                              ? context.error
                              : context.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Circular loading indicator with error state
                  GestureDetector(
                    onTap: controller.hasError.value ? controller.skipToHome : null,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (controller.hasError.value
                                ? context.error
                                : context.primary).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: controller.hasError.value
                          ? Icon(
                        Icons.error_outline,
                        color: context.error,
                        size: 32,
                      )
                          : CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildDebugSection(BuildContext context) {
    return Obx(() => AnimatedOpacity(
      opacity: controller.showProgress.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Debug Info',
              style: context.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.debugInfo.value.isNotEmpty)
              Text(
                controller.debugInfo.value,
                style: context.bodySmall.copyWith(
                  color: controller.hasError.value
                      ? context.error
                      : context.textSecondary,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: controller.skipToHome,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Skip to Home',
                  style: context.bodySmall.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildBottomSection(BuildContext context, ThemeController themeController) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Theme toggle and status (always visible in debug mode)
        if (kDebugMode) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Theme: ${themeController.themeStatusText}',
                  style: context.bodySmall.copyWith(
                    color: context.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => themeController.cycleTheme(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      themeController.currentThemeIcon,
                      size: 12,
                      color: context.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Version info (optional)
        Text(
          'v1.0.18+61',
          style: context.bodySmall.copyWith(
            color: context.textSecondary.withOpacity(0.6),
            fontSize: 10,
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}