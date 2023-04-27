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
          decoration: const InputDecoration(
            label: Text("Код"),
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
              onPressed: () => controller.changeOrganization(),
              child: const Text("Сложи нова организация"),
            ),
          ),
        ),
        FilledButton.tonalIcon(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.leaveOrganization(),
            label: const Text("Напусни организацията"))
      ],
    );
  }
}
