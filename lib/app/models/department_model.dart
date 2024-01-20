// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Department {
  String id;
  String description;
  String ownerId;

  Department({
    required this.id,
    required this.description,
    required this.ownerId,
  });

  Department copyWith({
    String? id,
    String? description,
    String? ownerId,
  }) {
    return Department(
      id: id ?? this.id,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'ownerId': ownerId,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map, [String? id]) {
    return Department(
      id: map['id'] as String,
      description: map['description'] as String,
      ownerId: map['ownerId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) => Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Department(id: $id, description: $description, ownerId: $ownerId)';
  }

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;

    return other.id == id && other.description == description && other.ownerId == ownerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ description.hashCode ^ ownerId.hashCode;
  }
}
