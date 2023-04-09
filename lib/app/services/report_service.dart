import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'geo_service.dart';

external DateTime add(Duration duration);

class ReportService {
  Future report(
    String name,
    String description,
    List<XFile> photos, {
    bool isAnonymous = false,
  }) async {
    final uuid = const Uuid().v4();
    LatLng location = await GeoService().getLocation();
    User? user = FirebaseAuth.instance.currentUser;

    final today = DateTime.now();

    var ReportData = <String, dynamic>{
      "name": name,
      "description": description,
      "date": today,
      "location": GeoPoint(location.latitude, location.longitude),
    };

    if (!isAnonymous) {
      ReportData.addAll({"reporterId": user!.uid});
    }

    var store = FirebaseFirestore.instance;
    var storage = FirebaseStorage.instance;

    var photosLinks = <String>[];
    var reference = storage.ref("reports/$uuid");
    for (var i = 0; i < photos.length; i++) {
      print(reference.fullPath);
      var ref = reference.child(i.toString());

      ref.putFile(File(photos[i].path));

      photosLinks.add(await ref.getDownloadURL());
    }

    ReportData.addAll({
      "images": photosLinks,
    });

    await store.collection("reports").doc(uuid).set(ReportData);
  }
}
