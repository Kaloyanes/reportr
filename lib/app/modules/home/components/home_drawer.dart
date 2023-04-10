import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: -1,
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
        )
      ],
    );
  }
}
