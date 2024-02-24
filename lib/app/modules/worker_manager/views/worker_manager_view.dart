import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/components/back_button.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/modules/worker_manager/components/worker_tile.dart';
import 'package:reportr/app/modules/worker_manager/controllers/worker_manager_controller.dart';

class WorkerManagerView extends GetView<WorkerManagerController> {
  const WorkerManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WorkerManagerController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('workers'.tr),
        centerTitle: true,
        leading: const CustomBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.addNewDepartment,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: controller.removeDepartment,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Obx(() {
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
              Department? department;
              if (controller.departments.isNotEmpty &&
                  (employee.departmentId != null ||
                      employee.departmentId != "")) {
                department = controller.departments.firstWhereOrNull(
                    (element) => element.id == employee.departmentId);
              }

              return Column(
                children: [
                  if (index == 0 ||
                      employee.departmentId !=
                          employees[index - 1].departmentId)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            department?.name ?? "no_department".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  WorkerTile(
                    employee: employee,
                    controller: controller,
                    hasDepartments: controller.departments.isNotEmpty,
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
