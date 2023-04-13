// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  String title;
  String description;
  DateTime date;
  String organization;
  String reporterId;
  GeoPoint location;
  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.organization,
    required this.reporterId,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'organization': organization,
      'reporterId': reporterId,
      'location': location,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map, String id) {
    if (!map.containsKey("reporterId")) map["reporterId"] = "anon";

    return Report(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch),
      organization: map['organization'] as String,
      reporterId: map['reporterId'] as String,
      location: map['location'] as GeoPoint,
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source, String id) => Report.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() {
    return 'Report(id: $id, title: $title, description: $description, date: $date, organization: $organization, reporterId: $reporterId, location: $location)';
  }

  Report copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? organization,
    String? reporterId,
    GeoPoint? location,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      organization: organization ?? this.organization,
      reporterId: reporterId ?? this.reporterId,
      location: location ?? this.location,
    );
  }
}
