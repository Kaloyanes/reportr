import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 30,
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: (message == null
          ? Container(
              height: 0,
            )
          : Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text("cancel".tr),
        ),
        FilledButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text("confirm".tr),
        ),
      ],
    );
  }
}
