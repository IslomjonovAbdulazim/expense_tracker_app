part of 'imports.dart';

class _LanguageItem extends StatelessWidget {
  final String name;
  final String flagCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageItem({
    Key? key,
    required this.name,
    required this.flagCode,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? context.primary.withOpacity(0.1) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Flag icon or language indicator
              Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  // You can use a flag package or just show the country code
                  color: context.cardColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  flagCode.toUpperCase(),
                  style: context.caption.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),

              // Language name
              Expanded(
                child: Text(
                  name,
                  style: context.body.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),

              // Selection indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: context.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}