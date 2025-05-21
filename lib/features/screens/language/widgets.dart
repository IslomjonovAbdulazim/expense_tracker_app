part of 'imports.dart';

class _LanguageItem extends StatelessWidget {
  final String name;
  final String flagCode;
  final bool isSelected;
  final VoidCallback onTap;
  final String? nativeName;  // Optional native language name

  const _LanguageItem({
    Key? key,
    required this.name,
    required this.flagCode,
    required this.isSelected,
    required this.onTap,
    this.nativeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Flag icon
              _buildFlag(context),
              const SizedBox(width: 16),

              // Language name and native name
              Expanded(child: _buildContent(context)),

              // Selection indicator
              isSelected
                  ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              )
                  : Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlag(BuildContext context) {
    // If you have a flag package, use it here
    return Container(
      width: 40,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        // You could use a real flag image here if available
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).cardColor.withOpacity(0.8),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        flagCode.toUpperCase(),
        style: context.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextStyle baseStyle = isSelected
        ? context.headingSmall.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    )
        : context.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: baseStyle,
        ),
        if (nativeName != null && nativeName != name)
          Text(
            nativeName!,
            style: context.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
      ],
    );
  }
}