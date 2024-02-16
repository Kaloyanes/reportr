import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reportr/app/modules/report_details/components/error_dialog.dart';
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

  Future<void> setStream({String? order}) async {
    order ??= settingsBox.read("order") ?? "date";
    var userData = await ProfileService().getProfileInfo();

    if (userData == null) {
      throw ArgumentError(
        "no_rights_or_havent_joined_org",
      );
    }

    if (userData["organization"].toString().trim().isEmpty) {
      showDialog(context: Get.context!, builder: (context) => ErrorDialog(message: "no_organization".tr));

      return;
    }

    var query = FirebaseFirestore.instance.collection("reports").where(
          "organization",
          isEqualTo:
              userData["role"] == "organization" ? FirebaseAuth.instance.currentUser!.uid : userData["organization"],
        );

    if (userData['role'] == "employee") {
      query = query.where("departmentId", isEqualTo: userData["departmentId"]);
    }

    stream.value = query.orderBy(order, descending: true).snapshots();
    await settingsBox.write("order", order);
  }

  Future<void> refreshList() async {
    var temp = stream.value;
    stream.value = const Stream.empty();
    stream.value = temp;
  }
}
