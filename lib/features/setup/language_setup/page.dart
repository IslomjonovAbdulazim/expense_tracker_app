// Enhanced language setup page with progress indicator
// lib/features/setup/language_setup/page.dart

part of 'imports.dart';

class LanguageSetupPage extends GetView<LanguageSetupController> {
  const LanguageSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator (only show if not from settings)
              Obx(() => !controller.isFromSettings.value
                  ? _buildProgressSection(context)
                  : const SizedBox.shrink()),

              // Header
              _buildHeader(context),

              const SizedBox(height: 32),

              // Language list
              Expanded(
                child: _buildLanguageList(context),
              ),

              const SizedBox(height: 24),

              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      children: [
        SetupProgressIndicator(
          currentStep: controller.currentStep - 1, // 0-indexed for display
          totalSteps: controller.totalSteps,
          stepLabels: controller.stepLabels,
          showLabels: true,
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${controller.currentStep} of ${controller.totalSteps}',
          style: context.bodySmall.copyWith(
            color: context.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.language,
            size: 40,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          controller.isFromSettings.value
              ? 'Change Language'
              : 'Choose Your Language',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          controller.isFromSettings.value
              ? 'Update your preferred language'
              : 'Select your preferred language for the app',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    return ListView.separated(
      itemCount: controller.languages.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final language = controller.languages[index];
        final locale = language['locale'] as Locale;

        return Obx(() => _LanguageCard(
          name: language['name'],
          nativeName: language['nativeName'],
          flag: language['flag'] ?? '🌐',
          isSelected: controller.isSelected(locale),
          onTap: () => controller.selectLanguage(locale),
        ));
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Obx(() => Column(
      children: [
        // Continue button
        PlatformButton.primary(
          text: controller.isFromSettings.value
              ? 'Update Language'
              : controller.selectedLocale.value != null
              ? 'Continue to Theme'
              : 'Select Language',
          onPressed: controller.selectedLocale.value != null
              ? controller.confirmSelection
              : null,
          isLoading: controller.isLoading.value,
          expanded: true,
          height: 56,
        ),

        if (!controller.isFromSettings.value) ...[
          const SizedBox(height: 12),

          // Skip button
          PlatformButton.text(
            text: 'Skip for now',
            onPressed: controller.skipLanguageSetup,
          ),

          const SizedBox(height: 8),

          // Info text
          Text(
            'You can change this later in Settings',
            style: context.bodySmall.copyWith(
              color: context.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ));
  }
}