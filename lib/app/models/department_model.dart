// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Department {
  String id;
  String type;
  String address;

  Department({
    required this.id,
    required this.type,
    required this.address,
  });

  Department copyWith({
    String? id,
    String? type,
    String? address,
  }) {
    return Department(
      id: id ?? this.id,
      type: type ?? this.type,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'address': address,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as String,
      type: map['type'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) => Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Department(id: $id, type: $type, address: $address)';

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;

    return other.id == id && other.type == type && other.address == address;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ address.hashCode;
}
