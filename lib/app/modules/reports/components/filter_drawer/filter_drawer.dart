import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/reports/components/filter_drawer/filter_drawer_controller.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FilterDrawerController());
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              "Филтри",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Divider(),
          const Text("Анонимно"),
          RadioListTile(value: 1, groupValue: 2, onChanged: (val) {}),
          RadioListTile(value: 2, groupValue: 2, onChanged: (val) {}),
          const Divider(),
        ],
      ),
    );
  }
}
