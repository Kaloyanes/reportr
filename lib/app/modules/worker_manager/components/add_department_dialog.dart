import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDepartmentDialog extends StatelessWidget {
  const AddDepartmentDialog(
      {super.key,
      required this.nameController,
      required this.descriptionController});

  final TextEditingController nameController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("create_department".tr),
      content: Form(
        child: SizedBox(
          width: 900,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "name".tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "fill_field".tr;
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AutoSizeTextField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                // minFontSize: 20,
                presetFontSizes: const [
                  18,
                  16,
                  14,
                  12,
                  10,
                  8,
                ],
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  labelText: "description".tr,
                  // contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("cancel".tr),
        ),
        FilledButton(
          onPressed: () => Get.back(),
          child: Text("create_department".tr),
        ),
      ],
    );
  }
}
