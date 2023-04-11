import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:reportr/app/services/auth_service.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerDestination(
            icon: CupertinoIcons.doc,
            label: "Докладвания",
            onTap: () => print("REPORTS"),
          ),
          DrawerDestination(
            icon: CupertinoIcons.profile_circled,
            label: "Профил",
            onTap: () => print("PROFILE"),
          ),
          const Spacer(),
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
