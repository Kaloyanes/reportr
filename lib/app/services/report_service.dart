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
      "location": location,
    };

    if (!isAnonymous) {
      ReportData.addAll({"reporterId": user!.uid});
    }

    var store = FirebaseFirestore.instance;

    var storage = FirebaseStorage.instance;

    var reference = storage.ref("reports/$uuid");
    for (var i = 0; i < photos.length; i++) {
      var photo = await photos[i].readAsBytes();

      reference.child("$i.png").putData(photo);
    }

    await store.collection("reports").doc(uuid).set(ReportData);
  }
}
