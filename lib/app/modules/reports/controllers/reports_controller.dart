import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reportr/app/services/profile_service.dart';

class ReportsContoller extends GetxController {
  Rx<Stream?> stream = const Stream.empty().obs;
  final scaffKey = GlobalKey<ScaffoldState>();
  final settingsBox = GetStorage("reportSettings");

  @override
  void onInit() {
    setStream();

    super.onInit();
  }

  Future<void> setStream() async {
    var userData = await ProfileService().getProfileInfo();

    if (userData == null) {
      throw ArgumentError(
        "no_rights_or_havent_joined_org",
      );
    }

    if (userData["organization"].toString().trim().isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: Text("no_organization".tr),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text("ok".tr),
            )
          ],
        ),
      );

      return;
    }

    var sd = FirebaseFirestore.instance.collection("reports").where(
          "organization",
          isEqualTo:
              userData["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : userData["organization"],
        );

    if (userData['role'] == "employee") {
      sd = sd.where("department", isEqualTo: userData["department"]);
    }

    stream.value = sd.orderBy(settingsBox.read("order") ?? "date", descending: true).snapshots();
  }

  Future refreshList() async {
    var temp = stream.value;

    stream.value = const Stream.empty();

    stream.value = temp;
  }

  Future sort(String order) async {
    var data = await ProfileService().getProfileInfo();

    if (data == null) {
      throw ArgumentError(
        "no_rights_or_havent_joined_org".tr,
      );
    }

    var strea = FirebaseFirestore.instance.collection("reports").where(
          "organization",
          isEqualTo: data["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : data["organization"],
        );

    var ordered = strea.orderBy(order, descending: true);

    if (order == "rating") ordered = ordered.orderBy("date", descending: true);

    stream.value = ordered.snapshots();
    await settingsBox.write("order", order);
  }
}
