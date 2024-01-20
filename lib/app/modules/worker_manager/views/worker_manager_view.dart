import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:reportr/app/components/back_button.dart';
import 'package:reportr/app/models/employee_model.dart';
import 'package:reportr/app/modules/worker_manager/components/worker_tile.dart';

import '../controllers/worker_manager_controller.dart';

class WorkerManagerView extends GetView<WorkerManagerController> {
  const WorkerManagerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WorkerManagerController());
    return Scaffold(
      appBar: AppBar(
        title: Text('workers'.tr),
        centerTitle: true,
        leading: const CustomBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.addNewDepartment,
          )
        ],
      ),
      body: Obx(() {
        var employees = controller.employees.value;

        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (employees.isEmpty) {
          return Center(
            child: Text("no_workers".tr),
          );
        }

        return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            var employee = employees[index];
            return WorkerTile(employee: employee, controller: controller);
          },
        );
      }),
    );
  }
}
