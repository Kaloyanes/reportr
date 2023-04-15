import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:reportr/app/services/profile_service.dart';

class ReportsContoller extends GetxController {
  Rx<Stream?> stream = const Stream.empty().obs;

  @override
  void onInit() {
    setStream();

    super.onInit();
  }

  Future setStream() async {
    var data = await ProfileService().getProfileInfo();

    if (data == null) {
      throw ArgumentError(
        "Нямате права или не сте влезли в организация",
      );
    }

    stream.value = FirebaseFirestore.instance
        .collection("reports")
        .where(
          "organization",
          isEqualTo: data["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : data["organization"],
        )
        .orderBy("date", descending: true)
        .snapshots();
  }

  Future refreshList() async {
    var temp = stream.value;

    stream.value = const Stream.empty();

    stream.value = temp;
  }
}
