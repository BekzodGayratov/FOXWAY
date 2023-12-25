// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:accountant/domain/price_model.dart';

class SumModel {
  String? id;
  final String? name;
  final Price? sum;
  final String? given_date;
  SumModel({
    this.id,
    this.name,
    this.sum,
    this.given_date,
  });

  SumModel copyWith({
    String? id,
    String? name,
    Price? sum,
    String? given_date,
  }) {
    return SumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sum: sum ?? this.sum,
      given_date: given_date ?? this.given_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'sum': sum?.toMap(),
      'given_date': given_date,
    };
  }

  factory SumModel.fromMap(Map<String, dynamic> map) {
    return SumModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      sum: map['sum'] != null
          ? Price.fromMap(map['sum'] as Map<String, dynamic>)
          : null,
      given_date:
          map['given_date'] != null ? map['given_date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SumModel.fromJson(String source) =>
      SumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SumModel(id: $id, name: $name, sum: $sum, given_date: $given_date)';
  }

  @override
  bool operator ==(covariant SumModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.sum == sum &&
        other.given_date == given_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ sum.hashCode ^ given_date.hashCode;
  }
}
