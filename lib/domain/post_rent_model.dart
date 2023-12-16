import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PostRentModel {
  final String? tenantName;
  final String? productType;
  final PostPrice? price;
  final PostPrice? paidDept;
  final String? givenDate;
  final String? receivedDate;
  final String? phoneNumber;
  final bool? isDelivered;
  PostRentModel({
    this.tenantName,
    this.productType,
    this.price,
    this.paidDept,
    this.givenDate,
    this.receivedDate,
    this.phoneNumber,
    this.isDelivered,
  });

  PostRentModel copyWith({
    String? tenantName,
    String? productType,
    PostPrice? price,
    PostPrice? paidDept,
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
      'price': price?.toMap(),
      'paidDept': paidDept?.toMap(),
      'givenDate': givenDate,
      'receivedDate': receivedDate,
      'phoneNumber': phoneNumber,
      'isDelivered': isDelivered,
    };
  }

  factory PostRentModel.fromMap(Map<String, dynamic> map) {
    return PostRentModel(
      tenantName: map['tenantName'] != null ? map['tenantName'] as String : null,
      productType: map['productType'] != null ? map['productType'] as String : null,
      price: map['price'] != null ? PostPrice.fromMap(map['price'] as Map<String,dynamic>) : null,
      paidDept: map['paidDept'] != null ? PostPrice.fromMap(map['paidDept'] as Map<String,dynamic>) : null,
      givenDate: map['givenDate'] != null ? map['givenDate'] as String : null,
      receivedDate: map['receivedDate'] != null ? map['receivedDate'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      isDelivered: map['isDelivered'] != null ? map['isDelivered'] as bool : null,
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

class PostPrice {
  final String? currency;
  final num? sum;
  PostPrice({
    this.currency,
    this.sum,
  });

  PostPrice copyWith({
    String? currency,
    num? sum,
  }) {
    return PostPrice(
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

  factory PostPrice.fromMap(Map<String, dynamic> map) {
    return PostPrice(
      currency: map['currency'] != null ? map['currency'] as String : null,
      sum: map['sum'] != null ? map['sum'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostPrice.fromJson(String source) => PostPrice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostPrice(currency: $currency, sum: $sum)';
}
