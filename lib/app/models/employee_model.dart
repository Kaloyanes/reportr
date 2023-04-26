// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Employee {
  String id;
  String email;
  String inviteCode;
  String name;
  String organization;
  String photoUrl;
  String role;
  Employee({
    required this.id,
    required this.email,
    required this.inviteCode,
    required this.name,
    required this.organization,
    required this.photoUrl,
    required this.role,
  });

  Employee copyWith({
    String? id,
    String? email,
    String? inviteCode,
    String? name,
    String? organization,
    String? photoUrl,
    String? role,
  }) {
    return Employee(
      id: id ?? this.id,
      email: email ?? this.email,
      inviteCode: inviteCode ?? this.inviteCode,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'inviteCode': inviteCode,
      'name': name,
      'organization': organization,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as String,
      email: map['email'] as String,
      inviteCode: map['inviteCode'] as String,
      name: map['name'] as String,
      organization: map['organization'] as String,
      photoUrl: map['photoUrl'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Employee(id: $id, email: $email, inviteCode: $inviteCode, name: $name, organization: $organization, photoUrl: $photoUrl, role: $role)';
  }

  @override
  bool operator ==(covariant Employee other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.inviteCode == inviteCode &&
        other.name == name &&
        other.organization == organization &&
        other.photoUrl == photoUrl &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        inviteCode.hashCode ^
        name.hashCode ^
        organization.hashCode ^
        photoUrl.hashCode ^
        role.hashCode;
  }
}
