import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PostClientModel {
  String? id;
  final String? clientName;
  final String? givenDate;
  final String? phoneNumber;
  PostClientModel({
    this.id,
    this.clientName,
    this.givenDate,
    this.phoneNumber,
  });

  PostClientModel copyWith({
    String? id,
    String? clientName,
    String? givenDate,
    String? phoneNumber,
  }) {
    return PostClientModel(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      givenDate: givenDate ?? this.givenDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clientName': clientName,
      'givenDate': givenDate,
      'phoneNumber': phoneNumber,
    };
  }

  factory PostClientModel.fromMap(Map<String, dynamic> map) {
    return PostClientModel(
      id: map['id'] != null ? map['id'] as String : null,
      clientName:
          map['clientName'] != null ? map['clientName'] as String : null,
      givenDate: map['givenDate'] != null ? map['givenDate'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostClientModel.fromJson(String source) =>
      PostClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostClientModel(id: $id, clientName: $clientName, givenDate: $givenDate, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant PostClientModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clientName == clientName &&
        other.givenDate == givenDate &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clientName.hashCode ^
        givenDate.hashCode ^
        phoneNumber.hashCode;
  }
}

