import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';

class ReportDetailsController extends GetxController {
  final Report report = Get.arguments["report"];
  final photos = [
    Get.arguments["thumbnail"],
  ].obs;
  final Reporter reporter = Get.arguments["reporter"];

  @override
  void onInit() {
    getImages(report);
    super.onInit();
  }

  Future getImages(Report report) async {
    var storage = FirebaseStorage.instance;

    var result = await storage.ref("reports/${report.id}").listAll();

    for (var pic in result.items.sublist(1)) {
      photos.add(await pic.getDownloadURL());
    }
  }

  final RxBool hasRated = false.obs;

  final reportRating = (Get.arguments["report"] as Report).rating.obs;

  final formatter = DateFormat("HH:mm:ss\ndd/MM/yyyy ");

  final pageController = PageController();

  Future delete() async {
    var confirm = await showDialog<bool>(
          context: Get.context!,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.warning),
            title: const Text("Желаете ли да изтриите ревюто завинаги?"),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Не"),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text("Да"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    Get.back();
    await FirebaseFirestore.instance.collection("reports").doc(report.id).delete();
  }

  updateRating() async {
    hasRated.value = true;
    await FirebaseFirestore.instance.collection("reports").doc(report.id).update({
      "rating": reportRating.value,
    });

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Променихте оценката"),
      ),
    );
  }
}
