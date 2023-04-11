import 'dart:io';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'geo_service.dart';

class ReportService {
  Future report(
    String orgId,
    String name,
    String description,
    List<XFile> photos, {
    bool isAnonymous = false,
  }) async {
    final uuid = const Uuid().v4();
    LatLng location = await GeoService().getLocation();
    User? user = FirebaseAuth.instance.currentUser;

    final today = DateTime.now();

    var reportData = <String, dynamic>{
      "organization": orgId,
      "name": name,
      "description": description,
      "date": today,
      "location": GeoPoint(location.latitude, location.longitude),
    };

    if (!isAnonymous) {
      reportData.addAll({"reporterId": user!.uid});
    }

    var store = FirebaseFirestore.instance;
    var storage = FirebaseStorage.instance;

    var photosLinks = <String>[];
    var reference = storage.ref("reports/$uuid");
    for (var i = 0; i < photos.length; i++) {
      var ref = reference.child(i.toString());
      ref.putFile(File(photos[i].path));

      photosLinks.add(await ref.getDownloadURL());
    }

    reportData.addAll({
      "images": photosLinks,
    });

    await store.collection("reports").doc(uuid).set(reportData);
  }
   Future<List<Map<String, dynamic>>> getReports(String orgid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("reports")
      .where("organization", isEqualTo: orgid)
      .get();

  return querySnapshot.docs.map((doc) => doc.data()).toList();
}

}
