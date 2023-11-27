import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:reportr/app/components/back_button.dart';
import 'package:reportr/app/modules/profile/components/profile_picture.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());
    return PopScope(
      onPopInvoked: (exit) => controller.exitPage(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("profile".tr),
          centerTitle: true,
          leading: const CustomBackButton(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  ProfilePicture(controller: controller),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(label: Text("name".tr)),
                    controller: controller.nameController,
                    onChanged: (value) => controller.savedSettings.value = true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text("email".tr)),
                    controller: controller.emailController,
                    onChanged: (value) => controller.savedSettings.value = true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => AnimatedSize(
                      alignment: Alignment.topCenter,
                      curve: Curves.easeOutExpo,
                      duration: 500.ms,
                      child: controller.roleChild.value,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                        fixedSize: const Size.fromWidth(200), backgroundColor: Colors.red.shade600),
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () => controller.deleteProfile(),
                    label: Text("delete_profile".tr),
                  ),
                  SizedBox(
                    height: Get.mediaQuery.viewPadding.bottom + 20,
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Obx(
          () => FloatingActionButton(
            elevation: 3,
            onPressed: () => controller.saveSettings(),
            heroTag: "saveButton",
            child: const Icon(Icons.save),
          )
              .animate(
                target: controller.savedSettings.value ? 1 : 0,
              )
              .scaleXY(
                curve: Curves.easeOutCubic,
                duration: 400.ms,
                // delay: 150.ms,
                begin: -0.5,
                end: 1,
              )
              .slideY(
                end: 0,
                begin: 5,
                curve: Curves.easeOutCubic,
                duration: 400.ms,
              )
              .then()
              .blurXY(
                begin: 3,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOut,
              ),
        ),
      ),
    );
  }
}
