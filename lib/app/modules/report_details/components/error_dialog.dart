import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning),
      title: Text(message),
      actions: [FilledButton.tonal(onPressed: () => Get.back(), child: Text("ok".tr))],
    );
  }
}
