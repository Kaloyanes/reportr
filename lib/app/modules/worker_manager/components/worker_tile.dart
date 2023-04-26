import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reportr/app/models/employee_model.dart';
import 'package:reportr/app/modules/worker_manager/controllers/worker_manager_controller.dart';

class WorkerTile extends StatelessWidget {
  const WorkerTile({
    super.key,
    required this.employee,
    required this.controller,
  });

  final Employee employee;
  final WorkerManagerController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.name),
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(employee.photoUrl),
        child: Text(controller.getInitials(employee.name)),
      ),
      trailing: PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 1:
              controller.removeUser(employee);
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<int>>[
          const PopupMenuItem(
            value: 1,
            child: Text("Премахнете потребителя", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
