import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  var settingsStorage = GetStorage("settings");
  final language = "".obs;

  @override
  void onInit() {
    getValues();

    super.onInit();
  }

  void getValues() {
    language.value = settingsStorage.read("language") ?? Get.deviceLocale!.toString();
  }

  Future setLanguage(String? value) async {
    if (value == null) return;

    language.value = value;

    Get.updateLocale(Locale(language.value));
    await HapticFeedback.mediumImpact();
    await settingsStorage.write("language", language.value);
  }
}
