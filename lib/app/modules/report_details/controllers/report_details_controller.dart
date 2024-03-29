import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/chats/views/chat_view.dart';
import 'package:reportr/app/modules/report_details/components/error_dialog.dart';
import 'package:reportr/app/services/ai_service.dart';
import 'package:reportr/app/services/department_service.dart';
import 'package:reportr/app/services/profile_service.dart';

class ReportDetailsController extends GetxController {
  final Report report = Get.arguments["report"];
  final photos = [
    Get.arguments["thumbnail"],
  ].obs;
  final Reporter reporter = Get.arguments["reporter"];
  final bool sender = Get.arguments["sender"];

  final isOrganization = false.obs;

  final RxBool hasRated = false.obs;

  final reportRating = (Get.arguments["report"] as Report).rating.obs;

  final formatter = DateFormat("HH:mm:ss\ndd/MM/yyyy ");

  final pageController = PageController();

  final departments = <Department>[].obs;

  final Rx<Department?> department = null.obs;
  final Rx<String> departmentId = "".obs;

  @override
  void onInit() {
    checkIfOrganization();
    getImages(report);
    getDepartments();

    super.onInit();
  }

  Future<void> getImages(Report report) async {
    var storage = FirebaseStorage.instance;

    var result = await storage.ref("reports/${report.id}").listAll();

    for (var pic in result.items.sublist(1)) {
      photos.add(await pic.getDownloadURL());
    }
  }

  Future<void> checkIfOrganization() async {
    printInfo(info: report.departmentId);
    var userData = await ProfileService().getProfileInfo();

    if (userData == null) return;

    isOrganization.value = userData["role"] == "organization";

    printInfo(info: "isOrganization: ${isOrganization.value}");
  }

  Future<void> getDepartments() async {
    departments.value = await DepartmentService().getDepartmentsByOwner();
    departmentId.value = report.departmentId;
    printInfo(
        info:
            "departments: ${departments.map((element) => "${element.name} ${element.id}")}");
    printInfo(info: "report DepartmentId: ${report.departmentId}");

    printInfo(info: "Assigned department");

    printInfo(info: "report Department: ${department.value}");
  }

  Future<void> delete() async {
    var confirm = await showDialog<bool>(
          context: Get.context!,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.warning,
              color: Colors.red,
            ),
            title: Text("delete_forever_report".tr),
            actions: [
              FilledButton(
                onPressed: () => Get.back(result: false),
                child: Text("no".tr),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                child: Text("yes".tr),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    Get.back();
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(report.id)
        .delete();
  }

  Future<void> updateRating() async {
    hasRated.value = true;
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(report.id)
        .update({
      "rating": reportRating.value,
    });

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("changed_rating".tr),
      ),
    );
  }

  Future<void> createChat() async {
    var store = FirebaseFirestore.instance;
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) =>
            ErrorDialog(message: "required_account_to_chat".tr),
      );

      return;
    }

    if (reporter.id == uid) {
      showDialog(
          context: Get.context!,
          builder: (context) =>
              ErrorDialog(message: "cant_type_to_yourself".tr));

      return;
    }

    var chatDocId = {"$uid.${reporter.id}", "${reporter.id}.$uid"};
    var collection = await store.collection("chats").get();
    var doc = collection.docs.firstWhereOrNull((element) =>
        element.id == chatDocId.elementAt(0) ||
        element.id == chatDocId.elementAt(1));

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
      "initials": reporter.name.trim().split(" ").map((e) => e[0]).join(""),
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

  Future<void> assignToDepartment() async {
    var selectedDepartment = await showDialog<Department?>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("assign_to_department".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 700,
              height: 500,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text("ai_department".tr),
                      onTap: () async {
                        try {
                          var department =
                              AiService().getDepartmentBasedOnReport(report);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            // false = user must tap button, true = tap outside dialog
                            builder: (BuildContext dialogContext) {
                              return const AlertDialog(
                                content: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          );

                          department.then((value) {
                            Get.back(result: value);
                            Get.back(result: value);
                          });
                        } catch (e) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text("error".tr),
                                content: Text(e.toString()),
                                actions: [
                                  FilledButton(
                                    onPressed: () => Get.back(),
                                    child: Text("ok".tr),
                                  ),
                                ],
                              );
                            },
                          );
                          Get.back(result: null);
                        }
                      },
                    );
                  }

                  return ListTile(
                    title: Text(departments[index - 1].name),
                    onTap: () => Get.back(result: departments[index - 1]),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: departments.length + 1,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
        ],
      ),
    );

    HapticFeedback.selectionClick();

    if (selectedDepartment == null) return;

    await DepartmentService()
        .assignReportToDepartment(report.id, selectedDepartment.id);

    departmentId.value = selectedDepartment.id;

    ScaffoldMessenger.of(Get.context!).clearSnackBars();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("assigned_to_department"
            .trParams({"department": selectedDepartment.name})),
      ),
    );
  }
}
