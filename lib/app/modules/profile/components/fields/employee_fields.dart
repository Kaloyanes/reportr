import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/profile/controllers/profile_controller.dart';

class EmployeeFields extends StatelessWidget {
  const EmployeeFields({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextFormField(
          controller: controller.inviteController,
          decoration: InputDecoration(
            label: Text("code".tr),
          ),
          onChanged: (value) => controller.inviteCodeChanged.value = true,
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(
          () => AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: 600.milliseconds,
            width: controller.inviteCodeChanged.value ? 300 : 0,
            height: controller.inviteCodeChanged.value ? 45 : 0,
            margin: EdgeInsets.only(bottom: controller.inviteCodeChanged.value ? 20 : 0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                fixedSize: const Size.fromWidth(200),
              ),
              onPressed: () => controller.changeOrganization(),
              child: Text("place_new_organization".tr),
            ),
          ),
        ),
        FilledButton.tonalIcon(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.leaveOrganization(),
            label: Text("leave_organization".tr))
      ],
    );
  }
}
