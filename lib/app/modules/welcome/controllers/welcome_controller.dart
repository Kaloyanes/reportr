import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController extends GetxController {
  GetStorage settingsStorage = GetStorage("settings");

  @override
  void onInit() {
    checkIfUserHasSeenWelcome();
    super.onInit();
  }

  void checkIfUserHasSeenWelcome() {
    if (settingsStorage.read<bool>("has_seen_welcome") ?? false) {
      Get.offNamed("/home");
    }
  }

  Future goToHome() async {
    await settingsStorage.write("has_seen_welcome", true);
    await HapticFeedback.mediumImpact();
    Get.toNamed('/home');
  }
}
