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
              "filters".tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Divider(),
          Obx(
            () => Column(
              children: [
                Text("type_of_reports".tr, style: Theme.of(context).textTheme.headlineSmall),
                RadioListTile(
                  value: 1,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 1,
                  title: Text("all".tr),
                  selected: controller.anonFilter.value == 1,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 2,
                  title: Text("only_by_registered_users".tr),
                  selected: controller.anonFilter.value == 2,
                ),
                RadioListTile(
                  value: 3,
                  groupValue: controller.anonFilter.value,
                  onChanged: (val) => controller.anonFilter.value = val ?? 3,
                  title: Text("only_anon".tr),
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
