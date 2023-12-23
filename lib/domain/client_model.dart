// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ClientModel {
  String? id;
  final String? client_name;
  final String? given_date;
  final String? phone_number;
  final String? created_at;
  final String? updated_at;
  final num? total_sum_uzs;
  final num? total_sum_usd;
  ClientModel({
    this.id,
    this.client_name,
    this.given_date,
    this.phone_number,
    this.created_at,
    this.updated_at,
    this.total_sum_uzs,
    this.total_sum_usd,
  });


  ClientModel copyWith({
    String? id,
    String? client_name,
    String? given_date,
    String? phone_number,
    String? created_at,
    String? updated_at,
    num? total_sum_uzs,
    num? total_sum_usd,
  }) {
    return ClientModel(
      id: id ?? this.id,
      client_name: client_name ?? this.client_name,
      given_date: given_date ?? this.given_date,
      phone_number: phone_number ?? this.phone_number,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      total_sum_uzs: total_sum_uzs ?? this.total_sum_uzs,
      total_sum_usd: total_sum_usd ?? this.total_sum_usd,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'client_name': client_name,
      'given_date': given_date,
      'phone_number': phone_number,
      'created_at': created_at,
      'updated_at': updated_at,
      'total_sum_uzs': total_sum_uzs,
      'total_sum_usd': total_sum_usd,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] != null ? map['id'] as String : null,
      client_name: map['client_name'] != null ? map['client_name'] as String : null,
      given_date: map['given_date'] != null ? map['given_date'] as String : null,
      phone_number: map['phone_number'] != null ? map['phone_number'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
      updated_at: map['updated_at'] != null ? map['updated_at'] as String : null,
      total_sum_uzs: map['total_sum_uzs'] != null ? map['total_sum_uzs'] as num : null,
      total_sum_usd: map['total_sum_usd'] != null ? map['total_sum_usd'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) => ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientModel(id: $id, client_name: $client_name, given_date: $given_date, phone_number: $phone_number, created_at: $created_at, updated_at: $updated_at, total_sum_uzs: $total_sum_uzs, total_sum_usd: $total_sum_usd)';
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.client_name == client_name &&
      other.given_date == given_date &&
      other.phone_number == phone_number &&
      other.created_at == created_at &&
      other.updated_at == updated_at &&
      other.total_sum_uzs == total_sum_uzs &&
      other.total_sum_usd == total_sum_usd;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      client_name.hashCode ^
      given_date.hashCode ^
      phone_number.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode ^
      total_sum_uzs.hashCode ^
      total_sum_usd.hashCode;
  }
}
