// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class RentModel {
  String? id;
  final String? tenant_name;
  final String? product_type;
  final String? price;
  final String? paid_dept;
  final String? given_date;
  final String? received_date;
  final String? phone_number;
  final bool? is_delivered;
  final String? created_at;
  final String? updated_at;
  RentModel({
    this.id,
    this.tenant_name,
    this.product_type,
    this.price,
    this.paid_dept,
    this.given_date,
    this.received_date,
    this.phone_number,
    this.is_delivered,
    this.created_at,
    this.updated_at,
  });

  RentModel copyWith({
    String? id,
    String? tenant_name,
    String? product_type,
    String? price,
    String? paid_dept,
    String? given_date,
    String? received_date,
    String? phone_number,
    bool? is_delivered,
    String? created_at,
    String? updated_at,
  }) {
    return RentModel(
      id: id ?? this.id,
      tenant_name: tenant_name ?? this.tenant_name,
      product_type: product_type ?? this.product_type,
      price: price ?? this.price,
      paid_dept: paid_dept ?? this.paid_dept,
      given_date: given_date ?? this.given_date,
      received_date: received_date ?? this.received_date,
      phone_number: phone_number ?? this.phone_number,
      is_delivered: is_delivered ?? this.is_delivered,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tenant_name': tenant_name,
      'product_type': product_type,
      'price': price,
      'paid_dept': paid_dept,
      'given_date': given_date,
      'received_date': received_date,
      'phone_number': phone_number,
      'is_delivered': is_delivered,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory RentModel.fromMap(Map<String, dynamic> map) {
    return RentModel(
      id: map['id'] != null ? map['id'] as String : null,
      tenant_name:
          map['tenant_name'] != null ? map['tenant_name'] as String : null,
      product_type:
          map['product_type'] != null ? map['product_type'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      paid_dept: map['paid_dept'] != null ? map['paid_dept'] as String : null,
      given_date:
          map['given_date'] != null ? map['given_date'] as String : null,
      received_date:
          map['received_date'] != null ? map['received_date'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      is_delivered:
          map['is_delivered'] != null ? map['is_delivered'] as bool : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RentModel.fromJson(String source) =>
      RentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RentModel(id: $id, tenant_name: $tenant_name, product_type: $product_type, price: $price, paid_dept: $paid_dept, given_date: $given_date, received_date: $received_date, phone_number: $phone_number, is_delivered: $is_delivered, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant RentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tenant_name == tenant_name &&
        other.product_type == product_type &&
        other.price == price &&
        other.paid_dept == paid_dept &&
        other.given_date == given_date &&
        other.received_date == received_date &&
        other.phone_number == phone_number &&
        other.is_delivered == is_delivered &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tenant_name.hashCode ^
        product_type.hashCode ^
        price.hashCode ^
        paid_dept.hashCode ^
        given_date.hashCode ^
        received_date.hashCode ^
        phone_number.hashCode ^
        is_delivered.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
