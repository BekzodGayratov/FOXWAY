import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PostClientModel {
  String? id;
  final String? clientName;
  final String? givenDate;
  final ProductModel? product;
  final String? phoneNumber;
  PostClientModel({
    this.clientName,
    this.givenDate,
    this.product,
    this.phoneNumber,
  });

  PostClientModel copyWith({
    String? clientName,
    String? givenDate,
    ProductModel? product,
    String? phoneNumber,
  }) {
    return PostClientModel(
      clientName: clientName ?? this.clientName,
      givenDate: givenDate ?? this.givenDate,
      product: product ?? this.product,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientName': clientName,
      'givenDate': givenDate,
      'product': product?.toMap(),
      'phoneNumber': phoneNumber,
    };
  }

  factory PostClientModel.fromMap(Map<String, dynamic> map) {
    return PostClientModel(
      clientName:
          map['clientName'] != null ? map['clientName'] as String : null,
      givenDate: map['givenDate'] != null ? map['givenDate'] as String : null,
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostClientModel.fromJson(String source) =>
      PostClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostClientModel(clientName: $clientName, givenDate: $givenDate, product: $product, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant PostClientModel other) {
    if (identical(this, other)) return true;

    return other.clientName == clientName &&
        other.givenDate == givenDate &&
        other.product == product &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return clientName.hashCode ^
        givenDate.hashCode ^
        product.hashCode ^
        phoneNumber.hashCode;
  }
}

class ProductModel {
  final String? productType;
  final Price? price;
  final Price? paidMoney;
  final String? givenDate;
  ProductModel({
    this.productType,
    this.price,
    this.paidMoney,
    this.givenDate,
  });

  ProductModel copyWith({
    String? productType,
    Price? price,
    Price? paidMoney,
    String? givenDate,
  }) {
    return ProductModel(
      productType: productType ?? this.productType,
      price: price ?? this.price,
      paidMoney: paidMoney ?? this.paidMoney,
      givenDate: givenDate ?? this.givenDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productType': productType,
      'price': price?.toMap(),
      'paidMoney': paidMoney?.toMap(),
      'givenDate': givenDate,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productType:
          map['productType'] != null ? map['productType'] as String : null,
      price: map['price'] != null
          ? Price.fromMap(map['price'] as Map<String, dynamic>)
          : null,
      paidMoney: map['paidMoney'] != null
          ? Price.fromMap(map['paidMoney'] as Map<String, dynamic>)
          : null,
      givenDate: map['givenDate'] != null ? map['givenDate'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(productType: $productType, price: $price, paidMoney: $paidMoney, givenDate: $givenDate)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.productType == productType &&
        other.price == price &&
        other.paidMoney == paidMoney &&
        other.givenDate == givenDate;
  }

  @override
  int get hashCode {
    return productType.hashCode ^
        price.hashCode ^
        paidMoney.hashCode ^
        givenDate.hashCode;
  }
}

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
