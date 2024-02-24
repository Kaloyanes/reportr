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

  Future<void> checkIfUserHasSeenWelcome() async {
    var init = await settingsStorage.initStorage;

    if (settingsStorage.read("has_seen_welcome") == null && !init) {
      await settingsStorage.write("has_seen_welcome", false);
    }

    if (settingsStorage.read<bool>("has_seen_welcome")!) {
      Get.offNamed("/home");
    }
  }

  Future<void> goToHome() async {
    await settingsStorage.write("has_seen_welcome", true);
    await HapticFeedback.mediumImpact();
    Get.toNamed('/home');
  }
}
