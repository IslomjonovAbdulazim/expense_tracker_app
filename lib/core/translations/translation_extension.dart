extension TranslationExtension on String {
  /// Get translated value of the string
  String get tr => this.tr;

  /// Get translated value with parameters
  String trParams(List<String> params) => this.trParams(params);

  /// Get translated plural form with parameters
  String trPluralParams(num count, List<String> params) =>
      this.trPluralParams(count, params);
}