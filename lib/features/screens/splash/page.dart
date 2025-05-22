// lib/features/screens/splash/page.dart
part of 'imports.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primary.withOpacity(0.1),
              context.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with subtle scale animation
                      Obx(() => AnimatedScale(
                        scale: controller.isInitialized.value ? 1.0 : 0.8,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: AdaptiveLogo(
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              // App name and tagline
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App name with fade animation
                    Obx(() => AnimatedOpacity(
                      opacity: controller.progress.value > 0.3 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        'Money Track',
                        style: context.headingLarge.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),

                    const SizedBox(height: 12),

                    // Tagline with slide animation
                    Obx(() => AnimatedSlide(
                      offset: controller.progress.value > 0.6
                          ? Offset.zero
                          : const Offset(0, 0.5),
                      duration: const Duration(milliseconds: 600),
                      child: AnimatedOpacity(
                        opacity: controller.progress.value > 0.6 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          'Track your expenses smartly',
                          style: context.bodyLarge.copyWith(
                            color: context.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              // Progress section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status message
                    Obx(() => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        controller.initializationMessage.value,
                        key: ValueKey(controller.initializationMessage.value),
                        style: context.bodyMedium.copyWith(
                          color: context.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),

                    const SizedBox(height: 24),

                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        children: [
                          // Linear progress bar
                          Obx(() => LinearProgressIndicator(
                            value: controller.progress.value,
                            backgroundColor: context.primary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.primary,
                            ),
                            minHeight: 4,
                          )),

                          const SizedBox(height: 16),

                          // Circular loading indicator
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}