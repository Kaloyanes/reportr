// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Reporter {
  String id;
  String name;
  String photoUrl;

  Reporter({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  Reporter copyWith({
    String? id,
    String? name,
    String? photoUrl,
  }) {
    return Reporter(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory Reporter.fromMap(Map<String, dynamic> map, String id) {
    return Reporter(
      id: id,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reporter.fromJson(String source, id) => Reporter.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() => 'Reporter(id: $id, name: $name, photoUrl: $photoUrl)';

  @override
  bool operator ==(covariant Reporter other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.photoUrl == photoUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ photoUrl.hashCode;

  factory Reporter.anon() => Reporter(id: "anon", name: "Анонимен", photoUrl: "");
}
