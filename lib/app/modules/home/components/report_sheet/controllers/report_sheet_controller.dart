import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_picker_dialog.dart';
import 'package:reportr/app/modules/home/components/report_sheet/components/photo_settings_sheet.dart';
import 'package:reportr/app/services/report_service.dart';

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
        var images = await ImagePicker().pickMultiImage(imageQuality: 70);

        selectedPhotos.addAll(images);
        break;

      // Camera
      case 2:
        var image = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 70);

        if (image == null) return;
        selectedPhotos.add(image);
        return;

      // Cancel the action
      case -1:
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
    String organizationName = selectedObject.value;

    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    await ReportService()
        .report(name, description, selectedPhotos, isAnonymous: true);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Докладът е изпратен успешно.")));

    selectedPhotos.value = [];
    nameController.clear();
    descriptionController.clear();
  }
}
