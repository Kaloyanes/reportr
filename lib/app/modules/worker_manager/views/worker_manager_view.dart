import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
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
      ),
      body: StreamBuilder(
        stream: controller.employeeStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          var employees = <Employee>[];

          for (var element in snapshot.data!.docs) {
            var data = element.data();

            data.addAll({"id": element.id});

            employees.add(Employee.fromMap(data));
          }

          if (employees.isEmpty) {
            return Center(
              child: Text(
                "no_workers".tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ).animate(delay: 500.ms).scaleXY(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: 600.ms,
                );
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              var employee = employees[index];
              return WorkerTile(employee: employee, controller: controller);
            },
          );
        },
      ),
    );
  }
}
