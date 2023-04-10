import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/sign_in/views/sign_in_view.dart';
import 'package:reportr/app/modules/sign_up/views/sign_up_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: -1,
      onDestinationSelected: (value) {
        switch (value) {
          case 0:
            Get.to(() => const SignInView());
            break;

          case 1:
            Get.to(() => const SignUpView());
            break;
        }
      },
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Center(
            child: Text(
              "ReportR",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.login),
          label: Text("Влез"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.app_registration),
          label: Text("Направи си акаунт"),
        ),
      ],
    );
  }
}
