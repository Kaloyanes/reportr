import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geo_service.dart';

external DateTime add(Duration duration);

class ReportService {
  Future report(String name, String description, List<XFile> photos,
      {bool isAnonymous = false}) async {
    LatLng location = await GeoService().getLocation();
    User? user = FirebaseAuth.instance.currentUser;

    final today = DateTime.now();

    var ReportData = <String, dynamic>{
      "name": name,
      "description": description,
      "date": today,
    };

    if (!isAnonymous) {
      ReportData.addAll({"reporterId": user!.uid});
    }

    var store = FirebaseFirestore.instance;

    await store.collection("reports").doc().set(ReportData);
    // TODO: Upload photos to firebase storage
  }
}
