part of 'imports.dart';

class _ThemeCard extends StatelessWidget {
  final AppThemeEnum theme;
  final String name;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.name,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? context.primary.withOpacity(0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? context.primary : context.dividerColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildThemePreview(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: context.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? context.primary : context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: context.bodySmall.copyWith(
                          color: context.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                isSelected
                    ? Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                )
                    : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.dividerColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    switch (theme) {
      case AppThemeEnum.light:
        backgroundColor = Colors.white;
        foregroundColor = Colors.black87;
        break;
      case AppThemeEnum.dark:
        backgroundColor = const Color(0xFF121212);
        foregroundColor = Colors.white;
        break;
      case AppThemeEnum.system:
        final brightness = Theme.of(context).brightness;
        backgroundColor = brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white;
        foregroundColor = brightness == Brightness.dark ? Colors.white : Colors.black87;
        break;
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: foregroundColor, size: 28),
    );
  }
}
