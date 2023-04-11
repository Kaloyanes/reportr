import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login(String email, String password) async =>
      await auth.signInWithEmailAndPassword(email: email, password: password);

  Future signUp({
    required String email,
    required String password,
    required String name,
    bool? isOrganisation,
    LatLng? locationCord,
    String? role,
    Color? organizationColor,
  }) async {
    var user = await auth.createUserWithEmailAndPassword(email: email, password: password);

    var docId = user.user!.uid;

    var store = FirebaseFirestore.instance;

    var data = <String, dynamic>{"email": email, "name": name};
    data.addAllIf(
      isOrganisation,
      {
        "location": GeoPoint(locationCord!.latitude, locationCord.longitude),
        "role": role,
        "color": organizationColor!.value,
        "isVerified": false,
      },
    );

    await store.collection("users").doc(docId).set(data);
  }

  Future logOut() async => await auth.signOut();

  Future forgotPassword(String email) async => await auth.sendPasswordResetEmail(email: email);
}
