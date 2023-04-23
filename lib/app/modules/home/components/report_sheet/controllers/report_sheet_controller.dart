import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_picker_dialog.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_settings_sheet.dart';
import 'package:reportr/app/services/report_service.dart';

class ReportSheetController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final sheetController = DraggableScrollableController();

  final selectedObject = "".obs;
  final selectedId = "".obs;

  final selectedPhotos = <XFile>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final anonReport = false.obs;

  void showReportForm(String name, String id) {
    selectedObject.value = name;
    selectedId.value = id;
    sheetController.animateTo(1, duration: 500.milliseconds, curve: Curves.easeOutQuart);
  }

  @override
  void onInit() {
    sheetController.addListener(() {
      print(sheetController.size);
      if (sheetController.size <= 0.2) {
        FocusScope.of(Get.context!).unfocus();
      }
    });
    super.onInit();
  }

  Future<void> addPhoto() async {
    int chosen = await showDialog<int>(
          context: Get.context!,
          builder: (context) => const PhotoPickerDialog(),
        ) ??
        -1;

    switch (chosen) {
      case 1:
        var images = await ImagePicker().pickMultiImage(imageQuality: 70);

        selectedPhotos.addAll(images);
        break;

      // Camera
      case 2:
        var image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
          preferredCameraDevice: CameraDevice.rear,
        );

        if (image == null) return;
        selectedPhotos.add(image);
        return;
    }
  }

  Future<void> photoSettings(int index) async {
    var photoSetting = await showDialog<int>(
      context: Get.context!,
      builder: (context) => const PhotoSettingsDialog(),
    );

    switch (photoSetting) {
      case 1:
        selectedPhotos.removeAt(index);
        break;
      case -1:
        return;
    }
  }

  Future<void> report() async {
    if (selectedId.value == "") {
      showError("Изберете организация от картата");
      return;
    }

    if (selectedPhotos.isEmpty) {
      showError("Не можете да нямате снимки");
      return;
    }

    if (!formKey.currentState!.validate()) return;

    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    await ReportService().report(
      selectedId.value,
      name,
      description,
      selectedPhotos,
      isAnonymous: FirebaseAuth.instance.currentUser == null ? true : anonReport.value,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Докладът е изпратен успешно.")));

    selectedPhotos.value = [];
    nameController.clear();
    descriptionController.clear();
    sheetController.animateTo(0.1, duration: 500.milliseconds, curve: Curves.easeOutQuart);
    FocusScope.of(Get.context!).unfocus();
  }

  Future<dynamic> showError(String title) {
    return showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("Oк"),
          ),
        ],
      ),
    );
  }
}
