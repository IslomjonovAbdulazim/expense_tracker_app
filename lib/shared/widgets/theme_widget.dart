// lib/shared/widgets/theme_widgets.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/services/theme_service.dart';
import '../../utils/extenstions/color_extension.dart';
import '../../utils/extenstions/text_style_extention.dart';

/// Theme switcher card for settings page
class ThemeSwitcherCard extends StatelessWidget {
  const ThemeSwitcherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: context.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Appearance',
                      style: context.headingSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Current: ${themeController.themeStatusText}',
                  style: context.bodyMedium.copyWith(
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ThemeOption(
                        theme: AppThemeEnum.light,
                        icon: Icons.light_mode,
                        label: 'Light',
                        isSelected: themeController.isTheme(AppThemeEnum.light),
                        onTap: () => themeController.setLightTheme(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeOption(
                        theme: AppThemeEnum.dark,
                        icon: Icons.dark_mode,
                        label: 'Dark',
                        isSelected: themeController.isTheme(AppThemeEnum.dark),
                        onTap: () => themeController.setDarkTheme(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeOption(
                        theme: AppThemeEnum.system,
                        icon: Icons.settings_brightness,
                        label: 'System',
                        isSelected: themeController.isTheme(AppThemeEnum.system),
                        onTap: () => themeController.setSystemTheme(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Individual theme option button
class _ThemeOption extends StatelessWidget {
  final AppThemeEnum theme;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.theme,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: context.primary, width: 2)
              : Border.all(color: context.dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.primary
                  : context.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.bodySmall.copyWith(
                color: isSelected
                    ? context.primary
                    : context.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple theme toggle button for app bar
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return IconButton(
          icon: Icon(themeController.currentThemeIcon),
          onPressed: () => themeController.cycleTheme(),
          tooltip: 'Change theme (${themeController.currentThemeName})',
        );
      },
    );
  }
}

/// Floating action button for quick theme switching (for testing)
class ThemeTestFAB extends StatelessWidget {
  const ThemeTestFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return FloatingActionButton.small(
          heroTag: "theme_fab",
          onPressed: () => themeController.cycleTheme(),
          tooltip: 'Test theme switching',
          backgroundColor: context.primary,
          child: Icon(
            themeController.currentThemeIcon,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// Theme status indicator (for debugging)
class ThemeStatusIndicator extends StatelessWidget {
  const ThemeStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                themeController.currentThemeIcon,
                size: 16,
                color: context.primary,
              ),
              const SizedBox(width: 6),
              Text(
                themeController.themeStatusText,
                style: context.bodySmall.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}