import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  Future profileEdit(String id, {String? newName, int? newColor, LatLng? changeLocation, XFile? newPhoto }) async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(id).get();
    var data = doc.data()!;

    data["name"] = newName;
    
    if (newColor != null) {
      data["color"] = newColor;
    }
    if (changeLocation != null) {
      data["location"] = changeLocation;
    }
    
    if (newPhoto != null) {

      final storageRef = FirebaseStorage.instance.ref("users/").child(id);
      await storageRef.putFile(File(newPhoto.path));

      final downloadURL = await storageRef.getDownloadURL();

      data["photoUrl"] = downloadURL;
    }
    
    await FirebaseFirestore.instance.collection("users").doc(id).update(data);
    
    return data;
  }
}