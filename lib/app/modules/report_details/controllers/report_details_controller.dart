import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/chats/views/chat_view.dart';

class ReportDetailsController extends GetxController {
  final Report report = Get.arguments["report"];
  final photos = [
    Get.arguments["thumbnail"],
  ].obs;
  final Reporter reporter = Get.arguments["reporter"];
  final bool sender = Get.arguments["sender"];

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
            title: const Text("Желаете ли да изтриите доклада завинаги?"),
            actions: [
              FilledButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Не"),
              ),
              FilledButton(
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

  Future<void> createChat() async {
    if (reporter.id == "anon") {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text(
            "Не можете да пишете на анонимен",
          ),
          actions: [
            FilledButton.tonal(
              onPressed: () => Get.back(),
              child: const Text("Oк"),
            ),
          ],
        ),
      );
      return;
    }

    var store = FirebaseFirestore.instance;
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text("Трябва да сте в акаунт за да можете да пишете на лично"),
          actions: [FilledButton.tonal(onPressed: () => Get.back(), child: const Text("Ок"))],
        ),
      );

      return;
    }

    if (reporter.id == uid) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text("Не можете да пишете на себе си"),
          actions: [FilledButton.tonal(onPressed: () => Get.back(), child: const Text("Ок"))],
        ),
      );

      return;
    }

    var chatDocId = {"$uid.${reporter.id}", "${reporter.id}.$uid"};
    var collection = await store.collection("chats").get();
    var doc = collection.docs
        .firstWhereOrNull((element) => element.id == chatDocId.elementAt(0) || element.id == chatDocId.elementAt(1));

    if (doc != null && doc.exists) {
      Get.to(() => const ChatView(), arguments: {
        "reporter": reporter,
        "docId": doc.id,
        "initials": "KS",
      });

      return;
    }

    var chatDoc = store.collection("chats").doc(chatDocId.elementAt(0));

    await chatDoc.set({"lastMessage": Timestamp.now(), "creator": uid});

    await chatDoc.collection("messages").doc("example").set({
      "time": Timestamp.now(),
      "sender": "",
      "value": "",
    });

    Get.to(() => const ChatView(), arguments: {
      "reporter": reporter,
      "docId": chatDocId.elementAt(0),
      "initials": "KS",
    });
  }

  void showPicture(String photoUrl) {
    showDialog(
      context: Get.context!,
      builder: (context) => Stack(
        fit: StackFit.loose,
        children: [
          Align(
            alignment: Alignment.center,
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              maxScale: 5,
              child: Hero(
                tag: photoUrl,
                child: CachedNetworkImage(
                  height: Get.height,
                  width: Get.width,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: imageProvider,
                    ),
                  ),
                  imageUrl: photoUrl,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => Get.back(),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ).animate().scaleXY(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: 600.ms,
          ),
    );
  }
}
