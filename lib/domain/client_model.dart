// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ClientModel {
  String? id;
  final String? client_name;
  final String? given_date;
  List<ProductModel?> products;
  final String? phone_number;
  final String? created_at;
  final String? updated_at;
  ClientModel({
    this.id,
    this.client_name,
    this.given_date,
    required this.products,
    this.phone_number,
    this.created_at,
    this.updated_at,
  });
  

  ClientModel copyWith({
    String? id,
    String? client_name,
    String? given_date,
    List<ProductModel?>? products,
    String? phone_number,
    String? created_at,
    String? updated_at,
  }) {
    return ClientModel(
      id: id ?? this.id,
      client_name: client_name ?? this.client_name,
      given_date: given_date ?? this.given_date,
      products: products ?? this.products,
      phone_number: phone_number ?? this.phone_number,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'client_name': client_name,
      'given_date': given_date,
      'products': products.map((x) => x?.toMap()).toList(),
      'phone_number': phone_number,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] != null ? map['id'] as String : null,
      client_name: map['client_name'] != null ? map['client_name'] as String : null,
      given_date: map['given_date'] != null ? map['given_date'] as String : null,
      products: List<ProductModel?>.from((map['products'] as List<int>).map<ProductModel?>((x) => ProductModel.fromMap(x as Map<String,dynamic>),),),
      phone_number: map['phone_number'] != null ? map['phone_number'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
      updated_at: map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) => ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientModel(id: $id, client_name: $client_name, given_date: $given_date, products: $products, phone_number: $phone_number, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.client_name == client_name &&
      other.given_date == given_date &&
      listEquals(other.products, products) &&
      other.phone_number == phone_number &&
      other.created_at == created_at &&
      other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      client_name.hashCode ^
      given_date.hashCode ^
      products.hashCode ^
      phone_number.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode;
  }
}

class ProductModel {
  final String? id;
  final String? product_type;
  final Price? price;
  final Price? paid_money;
  final String? given_date;
  final String? created_at;
  ProductModel({
    this.id,
    this.product_type,
    this.price,
    this.paid_money,
    this.given_date,
    this.created_at,
  });

  ProductModel copyWith({
    String? id,
    String? product_type,
    Price? price,
    Price? paid_money,
    String? given_date,
    String? created_at,
  }) {
    return ProductModel(
      id: id ?? this.id,
      product_type: product_type ?? this.product_type,
      price: price ?? this.price,
      paid_money: paid_money ?? this.paid_money,
      given_date: given_date ?? this.given_date,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_type': product_type,
      'price': price?.toMap(),
      'paid_money': paid_money?.toMap(),
      'given_date': given_date,
      'created_at': created_at,
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
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, product_type: $product_type, price: $price, paid_money: $paid_money, given_date: $given_date, created_at: $created_at)';
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
