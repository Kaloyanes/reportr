import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_picker_dialog.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_settings_sheet.dart';
import 'package:reportr/app/services/report_service.dart';

class ReportSheetController extends GetxController {
  final String id;
  ReportSheetController(this.id);

  final formKey = GlobalKey<FormState>();
  final sheetController = DraggableScrollableController();

  final selectedObject = "".obs;
  final selectedId = "".obs;

  final selectedPhotos = <XFile>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final anonReport = false.obs;

  void showReportForm({double progress = 0.7}) {
    sheetController.animateTo(progress, duration: 600.milliseconds, curve: Curves.easeInOutCubicEmphasized);
  }

  @override
  void onInit() {
    FocusScope.of(Get.context!).addListener(() {
      Timer(const Duration(milliseconds: 50), () {
        if (FocusScope.of(Get.context!).hasFocus) {
          showReportForm(progress: 0.9);
        }
      });
    });

    Timer(const Duration(milliseconds: 50), () {
      showReportForm();
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
    if (selectedPhotos.isEmpty) {
      showError("no_pictures_error".tr);
      return;
    }

    if (!formKey.currentState!.validate()) return;

    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    await ReportService().CreateReport(
      id,
      name,
      description,
      selectedPhotos,
      notAnon: anonReport.value,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("report_success".tr)));

    selectedPhotos.value = [];
    nameController.clear();
    descriptionController.clear();
    Get.back();
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
            child: Text("ok".tr),
          ),
        ],
      ),
    );
  }
}
