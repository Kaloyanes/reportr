import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:reportr/app/services/profile_service.dart';

class ReportsContoller extends GetxController {
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?> getStream() async {
    var data = await ProfileService().getProfileInfo();

    if (data == null) return null;

    return FirebaseFirestore.instance
        .collection("reports")
        .where(
          "organization",
          isEqualTo: data["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : data["organization"],
        )
        .snapshots();
  }
}
