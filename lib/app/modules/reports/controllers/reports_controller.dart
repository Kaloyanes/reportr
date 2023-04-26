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

  Future setStream() async {
    var data = await ProfileService().getProfileInfo();

    if (data == null) {
      throw ArgumentError(
        "Нямате права или не сте влезли в организация",
      );
    }

    if (data["organization"].toString().trim().isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text("Нямате организация"),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text("Ок"),
            )
          ],
        ),
      );

      return;
    }

    stream.value = FirebaseFirestore.instance
        .collection("reports")
        .where(
          "organization",
          isEqualTo: data["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : data["organization"],
        )
        .orderBy(settingsBox.read("order") ?? "date", descending: true)
        .snapshots();
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
        "Нямате права или не сте влезли в организация",
      );
    }

    var strea = FirebaseFirestore.instance.collection("reports").where(
          "organization",
          isEqualTo: data["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : data["organization"],
        );

    stream.value = strea.orderBy(order, descending: true).snapshots();

    await settingsBox.write("order", order);
  }
}
