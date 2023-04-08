import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoSettingsDialog extends StatelessWidget {
  const PhotoSettingsDialog({super.key});

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
            title: const Text("Изтрий снимката"),
            leading: const Icon(
              Icons.photo_rounded,
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              Get.back(result: -1);
            },
            title: const Text("Отказ"),
            leading: const Icon(
              Icons.cancel,
            ),
          ),
        ],
      ),
    );
  }
}
