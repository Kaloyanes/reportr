import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/reports/components/filter_drawer/filter_drawer_controller.dart';

class FilterDrawer extends GetView<FilterDrawerController> {
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
          Obx(
            () => Column(
              children: [
                Text("Какъв вид доклади?", style: Theme.of(context).textTheme.headlineSmall),
                RadioListTile(
                  value: 1,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 1,
                  title: const Text("Всички"),
                  selected: controller.anonFilter.value == 1,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 2,
                  title: const Text("Само от хора"),
                  selected: controller.anonFilter.value == 2,
                ),
                RadioListTile(
                  value: 3,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 3,
                  title: const Text("Само анонимни"),
                  selected: controller.anonFilter.value == 3,
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
