import 'dart:convert';

class Price {
  final String? currency;
  final num? sum;
  Price({
    this.currency,
    this.sum,
  });

  Price copyWith({
    String? currency,
    num? sum,
  }) {
    return Price(
      currency: currency ?? this.currency,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'sum': sum,
    };
  }

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      currency: map['currency'] != null ? map['currency'] as String : null,
      sum: map['sum'] != null ? map['sum'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Price.fromJson(String source) =>
      Price.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Price(currency: $currency, sum: $sum)';
}
