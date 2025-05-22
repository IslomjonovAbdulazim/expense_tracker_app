// lib/data/models/currency.dart
class Currency {
  final String code;
  final String name;
  final String symbol;
  final int decimalPlaces;
  final String? flag;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    this.decimalPlaces = 2,
    this.flag,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
      flag: json['flag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'decimalPlaces': decimalPlaces,
      'flag': flag,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Currency &&
              runtimeType == other.runtimeType &&
              code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$name ($code)';
}