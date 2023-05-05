import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/reports/controllers/reports_controller.dart';
import 'package:reportr/app/services/profile_service.dart';

class FilterDrawerController extends GetxController {
  final anonFilter = 1.obs;
  final reportController = Get.find<ReportsContoller>();

  @override
  void onInit() {
    super.onInit();
    setListeners();
  }

  void setListeners() {
    anonFilter.listen((val) async {
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

      switch (val) {
        case 1:
          reportController.stream.value =
              strea.orderBy(reportController.settingsBox.read("order") ?? "date", descending: true).snapshots();
          break;
        case 2:
          reportController.stream.value = strea
              // .orderBy(reportController.settingsBox.read("order") ?? "date", descending: true)
              .where("reporterId", isNotEqualTo: "anon")
              .snapshots();
          break;
        case 3:
          reportController.stream.value = strea
              .where("reporterId", isEqualTo: "anon")
              .orderBy(reportController.settingsBox.read("order") ?? "date", descending: true)
              .snapshots();
          break;
      }
    });
  }
}
