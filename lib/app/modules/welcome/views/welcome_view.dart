import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomeController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Text('welcome'.tr,
                style: Theme.of(context).textTheme.headlineMedium),
            const Spacer(),
            Align(
              child: FilledButton(
                onPressed: () => controller.goToHome(),
                child: Text(
                  'get_started'.tr,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
