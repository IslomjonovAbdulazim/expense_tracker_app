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
          'Choose Your Language',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Select your preferred language for the app',
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
          text: controller.isFromSettings.value ? 'Update Language' : 'Continue',
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
        ],
      ],
    ));
  }
}