import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_picker_dialog.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_settings_sheet.dart';

class ReportSheetController extends GetxController {
  final sheetController = DraggableScrollableController();
  final selectedObject = "".obs;

  final selectedPhotos = <XFile>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final anonReport = false.obs;

  void showReportForm(String name) {
    selectedObject.value = name;
    sheetController.animateTo(1,
        duration: 500.milliseconds, curve: Curves.fastLinearToSlowEaseIn);
  }

  Future<void> addPhoto() async {
    int chosen = await showDialog<int>(
          context: Get.context!,
          builder: (context) => const PhotoPickerDialog(),
        ) ??
        -1;

    var imageSource = ImageSource.camera;

    switch (chosen) {
      case 1:
        imageSource = ImageSource.gallery;
        break;

      // Camera
      case 2:
        break;

      // Cancel the action
      case -1:
        return;
    }

    var image = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 80,
    );

    if (image == null) return;

    selectedPhotos.add(image);
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

  void report() {
    String organizationName = selectedObject.value;

    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    // TODO: CONNECT TO REPORT SERVICE
  }
}
