import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/chats/views/chats_view.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:reportr/app/modules/my_reports/views/my_reports_view.dart';
import 'package:reportr/app/modules/profile/views/profile_view.dart';
import 'package:reportr/app/modules/reports/views/reports_view.dart';
import 'package:reportr/app/modules/worker_manager/views/worker_manager_view.dart';
import 'package:reportr/app/services/auth_service.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (role == "organization" || role == "employee")
            DrawerDestination(
              icon: CupertinoIcons.doc,
              label: "Докладвания",
              onTap: () => Get.to(() => const ReportsView()),
            ),
          if (role == "reporter")
            DrawerDestination(
              icon: CupertinoIcons.doc,
              label: "Мойте доклади",
              onTap: () => Get.to(() => const MyReportsView()),
            ),
          DrawerDestination(
            icon: CupertinoIcons.chat_bubble,
            label: "Чатове",
            onTap: () => Get.to(
              () => const ChatsView(),
            ),
          ),
          if (role == "organization")
            DrawerDestination(
              icon: Icons.person_search,
              label: "Работници",
              onTap: () => Get.to(() => const WorkerManagerView()),
            ),
          const Spacer(),
          DrawerDestination(
            icon: CupertinoIcons.profile_circled,
            label: "Профил",
            onTap: () => Get.to(() => const ProfileView()),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.logout,
            label: "Излез",
            onTap: () async => await AuthService().logOut(),
          ),
        ],
      ),
    );
  }
}
