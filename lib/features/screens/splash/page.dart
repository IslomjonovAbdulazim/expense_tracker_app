part of 'imports.dart';

class SplashPage extends GetView<_Controller> {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: controller.logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: controller.logoAnimation.value,
                    child: FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: context.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AdaptiveLogo(
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // App Name with Animation
              AnimatedBuilder(
                animation: controller.textAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.textAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Money Track',
                          style: context.headingLarge.copyWith(
                            color: context.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SlideTransition(
                          position: controller.slideAnimation,
                          child: FadeTransition(
                            opacity: controller.textAnimation,
                            child: Text(
                              'Track your expenses smartly',
                              style: context.headingMedium.copyWith(
                                color: context.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Loading Animation
              AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}