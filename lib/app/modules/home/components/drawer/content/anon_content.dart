import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:reportr/app/modules/settings/views/settings_view.dart';
import 'package:reportr/app/modules/sign_in/views/sign_in_view.dart';
import 'package:reportr/app/modules/sign_up/views/sign_up_view.dart';

class AnonContent extends StatelessWidget {
  const AnonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerDestination(
            icon: Icons.login,
            label: "sign_in".tr,
            onTap: () => Get.to(() => const SignInView()),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.app_registration_rounded,
            label: "create_account".tr,
            onTap: () => Get.to(() => const SignUpView()),
          ),
          const Spacer(),
          DrawerDestination(
            icon: Icons.settings,
            label: "settings".tr,
            onTap: () => Get.to(() => const SettingsView()),
          ),
        ],
      ),
    );
  }
}
