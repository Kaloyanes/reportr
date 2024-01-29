import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/employee_model.dart';
import 'package:reportr/app/modules/worker_manager/controllers/worker_manager_controller.dart';

class WorkerTile extends StatelessWidget {
  const WorkerTile({
    super.key,
    required this.employee,
    required this.controller,
    required this.hasDepartments,
  });

  final Employee employee;
  final WorkerManagerController controller;
  final bool hasDepartments;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.name),
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(employee.photoUrl),
        child: Text(controller.getInitials(employee.name)),
      ),
      trailing: PopupMenuButton(
        clipBehavior: Clip.hardEdge,
        onSelected: (value) {
          switch (value) {
            case 1:
              controller.removeUser(employee);
              break;

            case 2:
              controller.assignUser(employee);
              break;

            case 3:
              controller.removeUserFromDepartment(employee);
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<int>>[
          PopupMenuItem(
            value: 2,
            child: Text("assign_user".tr),
          ),
          if (employee.departmentId != null)
            PopupMenuItem(
              value: 3,
              child: Text(
                "remove_from_department".tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          PopupMenuItem(
            value: 1,
            child: Text(
              "remove_user".tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
