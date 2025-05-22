part of 'imports.dart';

class ThemeSetupPage extends GetView<ThemeSetupController> {
  const ThemeSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  Expanded(child: _buildThemeOptions(context)),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
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
          child: Icon(Icons.palette, size: 40, color: context.primary),
        ),
        const SizedBox(height: 24),
        Text(
          'Choose Your Theme',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Select the appearance that suits your preference',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildThemeOptions(BuildContext context) {
    return ListView.separated(
      itemCount: AppThemeEnum.values.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final theme = AppThemeEnum.values[index];
        return Obx(() => _ThemeCard(
          theme: theme,
          name: controller.getThemeName(theme),
          description: controller.getThemeDescription(theme),
          icon: controller.getThemeIcon(theme),
          isSelected: controller.isSelected(theme),
          onTap: () => controller.selectTheme(theme),
        ));
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Obx(() => Column(
      children: [
        PlatformButton.primary(
          text: controller.isFromSettings.value ? 'Update Theme' : 'Continue',
          onPressed: controller.selectedTheme.value != null
              ? controller.confirmSelection
              : null,
          isLoading: controller.isLoading.value,
          expanded: true,
          height: 56,
        ),
        if (!controller.isFromSettings.value) ...[
          const SizedBox(height: 12),
          PlatformButton.text(
            text: 'Skip for now',
            onPressed: controller.skipThemeSetup,
          ),
        ],
      ],
    ));
  }
}
