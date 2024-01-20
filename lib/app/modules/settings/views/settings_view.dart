import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:reportr/app/components/back_button.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
        leading: const CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("language".tr),
              trailing: Obx(
                () => DropdownButton(
                  value: controller.language.value,
                  items: const [
                    DropdownMenuItem(
                      value: "en_US",
                      child: Text("English"),
                    ),
                    DropdownMenuItem(
                      value: "bg_BG",
                      child: Text("Български"),
                    ),
                    DropdownMenuItem(
                      value: "de_DE",
                      child: Text("Deutsch"),
                    ),
                    DropdownMenuItem(
                      value: "ru_RU",
                      child: Text("Русский"),
                    ),
                  ],
                  onChanged: controller.setLanguage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
