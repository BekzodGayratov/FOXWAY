// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostRentModel {
  final String tenantName;
  final String productType;
  final String price;
  final String paidDept;
  final String givenDate;
  final String receivedDate;
  final String phoneNumber;
  final bool isDelivered;
  PostRentModel({
    required this.tenantName,
    required this.productType,
    required this.price,
    required this.paidDept,
    required this.givenDate,
    required this.receivedDate,
    required this.phoneNumber,
    required this.isDelivered,
  });

  PostRentModel copyWith({
    String? tenantName,
    String? productType,
    String? price,
    String? paidDept,
    String? givenDate,
    String? receivedDate,
    String? phoneNumber,
    bool? isDelivered,
  }) {
    return PostRentModel(
      tenantName: tenantName ?? this.tenantName,
      productType: productType ?? this.productType,
      price: price ?? this.price,
      paidDept: paidDept ?? this.paidDept,
      givenDate: givenDate ?? this.givenDate,
      receivedDate: receivedDate ?? this.receivedDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tenantName': tenantName,
      'productType': productType,
      'price': price,
      'paidDept': paidDept,
      'givenDate': givenDate,
      'receivedDate': receivedDate,
      'phoneNumber': phoneNumber,
      'isDelivered': isDelivered,
    };
  }

  factory PostRentModel.fromMap(Map<String, dynamic> map) {
    return PostRentModel(
      tenantName: map['tenantName'] as String,
      productType: map['productType'] as String,
      price: map['price'] as String,
      paidDept: map['paidDept'] as String,
      givenDate: map['givenDate'] as String,
      receivedDate: map['receivedDate'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isDelivered: map['isDelivered'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostRentModel.fromJson(String source) => PostRentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostRentModel(tenantName: $tenantName, productType: $productType, price: $price, paidDept: $paidDept, givenDate: $givenDate, receivedDate: $receivedDate, phoneNumber: $phoneNumber, isDelivered: $isDelivered)';
  }

  @override
  bool operator ==(covariant PostRentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.tenantName == tenantName &&
      other.productType == productType &&
      other.price == price &&
      other.paidDept == paidDept &&
      other.givenDate == givenDate &&
      other.receivedDate == receivedDate &&
      other.phoneNumber == phoneNumber &&
      other.isDelivered == isDelivered;
  }

  @override
  int get hashCode {
    return tenantName.hashCode ^
      productType.hashCode ^
      price.hashCode ^
      paidDept.hashCode ^
      givenDate.hashCode ^
      receivedDate.hashCode ^
      phoneNumber.hashCode ^
      isDelivered.hashCode;
  }
}
