import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/department_model.dart';

class DepartmentDialog extends StatelessWidget {
  const DepartmentDialog(
      {super.key, required this.title, required this.departments});

  final String title;
  final List<Department> departments;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: SizedBox(
        width: 700,
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(departments[index].name),
              onTap: () => Get.back(result: departments[index]),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: departments.length,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("cancel".tr),
        ),
      ],
    ).animate().scaleXY(
        curve: Curves.easeInOutCubicEmphasized, duration: 500.ms, begin: 0.5);
  }
}
