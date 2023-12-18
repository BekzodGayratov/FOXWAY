// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ClientModel {
  String? id;
  final String? client_name;
  final String? given_date;
  final List<ProductModel?> products;
  ClientModel({
    this.id,
    this.client_name,
    this.given_date,
    required this.products,
  });

  ClientModel copyWith({
    String? id,
    String? client_name,
    String? given_date,
    List<ProductModel?>? products,
  }) {
    return ClientModel(
      id: id ?? this.id,
      client_name: client_name ?? this.client_name,
      given_date: given_date ?? this.given_date,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'client_name': client_name,
      'given_date': given_date,
      'products': products.map((x) => x?.toMap()).toList(),
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
        id: map['id'] != null ? map['id'] as String : null,
        client_name:
            map['client_name'] != null ? map['client_name'] as String : null,
        given_date:
            map['given_date'] != null ? map['given_date'] as String : null,
        products: (map['products'] as List)
            .map((e) => ProductModel.fromMap(e))
            .toList());
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) =>
      ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientModel(id: $id, client_name: $client_name, given_date: $given_date, products: $products)';
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.client_name == client_name &&
        other.given_date == given_date &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        client_name.hashCode ^
        given_date.hashCode ^
        products.hashCode;
  }
}

class ProductModel {
  final String? id;
  final String? product_type;
  final Price? price;
  final Price? paid_money;
  final String? given_date;
  final String? phone_number;
  ProductModel({
    this.id,
    this.product_type,
    this.price,
    this.paid_money,
    this.given_date,
    this.phone_number,
  });

  ProductModel copyWith({
    String? id,
    String? product_type,
    Price? price,
    Price? paid_money,
    String? given_date,
    String? phone_number,
  }) {
    return ProductModel(
      id: id ?? this.id,
      product_type: product_type ?? this.product_type,
      price: price ?? this.price,
      paid_money: paid_money ?? this.paid_money,
      given_date: given_date ?? this.given_date,
      phone_number: phone_number ?? this.phone_number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_type': product_type,
      'price': price?.toMap(),
      'paid_money': paid_money?.toMap(),
      'given_date': given_date,
      'phone_number': phone_number,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      product_type:
          map['product_type'] != null ? map['product_type'] as String : null,
      price: map['price'] != null
          ? Price.fromMap(map['price'] as Map<String, dynamic>)
          : null,
      paid_money: map['paid_money'] != null
          ? Price.fromMap(map['paid_money'] as Map<String, dynamic>)
          : null,
      given_date:
          map['given_date'] != null ? map['given_date'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, product_type: $product_type, price: $price, paid_money: $paid_money, given_date: $given_date, phone_number: $phone_number)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product_type == product_type &&
        other.price == price &&
        other.paid_money == paid_money &&
        other.given_date == given_date &&
        other.phone_number == phone_number;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product_type.hashCode ^
        price.hashCode ^
        paid_money.hashCode ^
        given_date.hashCode ^
        phone_number.hashCode;
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
