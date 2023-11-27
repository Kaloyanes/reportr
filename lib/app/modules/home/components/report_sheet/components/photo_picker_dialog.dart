import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class PhotoPickerDialog extends StatelessWidget {
  const PhotoPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              Get.back(result: 1);
            },
            title: Text("gallery".tr),
            leading: const Icon(
              Icons.photo_rounded,
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              Get.back(result: 2);
            },
            title: Text("camera".tr),
            leading: const Icon(
              Icons.camera,
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              Get.back(result: -1);
            },
            title: Text("cancel".tr),
            leading: const Icon(
              Icons.cancel,
            ),
          ),
        ],
      ),
    ).animate().scaleXY(
          begin: 0,
          end: 1,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: 700.ms,
        );
  }
}
