// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Department {
  String id;
  String type;
  String address;
  String ownerId;

  Department({
    required this.id,
    required this.type,
    required this.address,
    required this.ownerId,
  });

  Department copyWith({
    String? id,
    String? type,
    String? address,
    String? ownerId,
  }) {
    return Department(
      id: id ?? this.id,
      type: type ?? this.type,
      address: address ?? this.address,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'address': address,
      'ownerId': ownerId,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map, [String? id]) {
    return Department(
      id: map['id'] as String,
      type: map['type'] as String,
      address: map['address'] as String,
      ownerId: map['ownerId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) => Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Department(id: $id, type: $type, address: $address, ownerId: $ownerId)';
  }

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.type == type &&
      other.address == address &&
      other.ownerId == ownerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      address.hashCode ^
      ownerId.hashCode;
  }
}
