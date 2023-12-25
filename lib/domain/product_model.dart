// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:accountant/domain/price_model.dart';

class ProductModel {
   String? id;
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

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product_type == product_type &&
        other.price == price &&
        other.paid_money == paid_money &&
        other.given_date == given_date &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product_type.hashCode ^
        price.hashCode ^
        paid_money.hashCode ^
        given_date.hashCode ^
        created_at.hashCode;
  }
}
