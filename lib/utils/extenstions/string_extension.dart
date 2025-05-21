// lib/utils/extensions/string_extensions.dart
extension StringExtensions on String {
  /// Check if a string is a valid email.
  bool get isValidEmail {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(this);
  }

  /// Capitalize the first letter of the string.
  String get capitalize {
    if (isEmpty) return "";
    return this[0].toUpperCase() + substring(1);
  }

  /// Convert a string to title case (capitalize first letter of each word).
  String get titleCase {
    if (isEmpty) return "";
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncate string with ellipsis if it exceeds the given length.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Convert a kebab-case or snake_case string to camelCase.
  String get toCamelCase {
    if (isEmpty) return "";
    return replaceAllMapped(
        RegExp(r'[-_](\w)'),
            (match) => match.group(1)!.toUpperCase()
    );
  }

  /// Remove all HTML tags from a string.
  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Check if a string contains only digits.
  bool get isNumeric {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }

  /// Create an abbreviated version of a multi-word string (e.g., "New York" -> "NY").
  String get initials {
    if (isEmpty) return "";

    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join('');
  }

  /// Convert string to URL-friendly slug.
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Check if a string is a valid URL.
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  /// Get a masked version of a credit card or phone number.
  String mask({int visibleChars = 4, String maskChar = '*'}) {
    if (length <= visibleChars) return this;

    final visible = substring(length - visibleChars);
    final masked = maskChar * (length - visibleChars);

    return masked + visible;
  }
}