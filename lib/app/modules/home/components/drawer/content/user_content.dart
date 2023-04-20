import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:reportr/app/modules/profile/views/profile_view.dart';
import 'package:reportr/app/modules/reports/views/reports_view.dart';
import 'package:reportr/app/services/auth_service.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          DrawerDestination(
            icon: CupertinoIcons.doc,
            label: "Докладвания",
            onTap: () => Get.to(const ReportsView()),
          ),
          const Spacer(),
          DrawerDestination(
            icon: CupertinoIcons.profile_circled,
            label: "Профил",
            onTap: () => Get.to(const ProfileView()),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.logout,
            label: "Излез",
            onTap: () {
              AuthService().logOut();
            },
          ),
        ],
      ),
    );
  }
}
