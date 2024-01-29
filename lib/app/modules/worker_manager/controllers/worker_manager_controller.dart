import 'dart:developer';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/models/employee_model.dart';
import 'package:reportr/app/services/department_service.dart';
import 'package:uuid/uuid.dart';

class WorkerManagerController extends GetxController with GetSingleTickerProviderStateMixin {
  //TODO: Implement WorkerManagerController

  RxList<Employee> employees = <Employee>[].obs;
  final RxBool loading = true.obs;
  final employeeStream = FirebaseFirestore.instance
      .collection("users")
      .where(
        "organization",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
      .snapshots();

  final departmentStream = FirebaseFirestore.instance
      .collection("departments")
      .where(
        "ownerId",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
      .snapshots();

  final departments = <Department>[].obs;

  late AnimationController _animationController;

  @override
  void onInit() {
    super.onInit();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    getDepartments();
  }

  Future<void> getDepartments() async {
    departmentStream.listen((event) {
      departments.clear();

      for (var element in event.docs) {
        var data = element.data();

        data.addAll({"id": element.id});

        departments.add(Department.fromMap(data));
      }
    });

    employeeStream.listen((event) async {
      employees.clear();

      for (var element in event.docs) {
        var data = element.data();

        data.addAll({"id": element.id});

        employees.add(Employee.fromMap(data));
      }

      employees.sort(
        (a, b) {
          // sort by department and name
          if (a.departmentId == b.departmentId) {
            return a.name.compareTo(b.name);
          }

          if (a.departmentId == null || a.departmentId == "") {
            return 1;
          }

          if (b.departmentId == null || b.departmentId == "") {
            return -1;
          }

          return a.departmentId!.compareTo(b.departmentId!);
        },
      );

      loading.value = false;
    });
  }

  String getInitials(String name) {
    var initials = "";

    name.trim().split(" ").forEach((element) {
      initials += element[0];
    });

    return initials;
  }

  Future removeUser(Employee employee) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(employee.id)
        .update({"organization": "", "inviteCode": ""});
  }

  Future addNewDepartment() async {
    var nameController = TextEditingController();
    var descriptionController = TextEditingController();

    await showModalBottomSheet(
      useSafeArea: true,
      context: Get.context!,
      enableDrag: true,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: 0.85,
      transitionAnimationController: _animationController,
      builder: (context) => Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text("create_department".tr, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "name".tr,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "fill_field".tr;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AutoSizeTextField(
                      keyboardType: TextInputType.multiline,
                      controller: descriptionController,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      // minFontSize: 20,
                      presetFontSizes: const [
                        18,
                        16,
                        14,
                        12,
                        10,
                        8,
                      ],
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        labelText: "description".tr,
                        // contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("cancel".tr),
                ),
                FilledButton(
                  onPressed: () => Get.back(),
                  child: Text("create_department".tr),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 5),
          ],
        ),
      ),
    );

    if (nameController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
      return;
    }

    await DepartmentService().createDepartment(nameController.text.trim(), descriptionController.text.trim());
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("department_created".tr),
      ),
    );
  }

  Future<void> assignUser(Employee employee) async {
    if (departments.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("no_departments".tr),
        ),
      );

      return;
    }

    bool hasChanged = false;

    var selectedDepartment = departments.firstWhereOrNull((element) => element.id == employee.departmentId);
    departments.sort((a, b) => a.name.compareTo(b.name));

    var resume = await showDialog<bool>(
      useSafeArea: true,
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("assign_user".tr, style: Theme.of(context).textTheme.titleLarge),
        content: Form(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "choose_department".tr,
            ),
            value: selectedDepartment,
            items: departments.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
            onChanged: (value) {
              hasChanged = selectedDepartment?.id != value?.id;
              selectedDepartment = value;
            },
            validator: (value) {
              if (value == null) {
                return "fill_field".tr;
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text("cancel".tr),
          ),
          FilledButton(
            onPressed: () async {
              Get.back(result: true);
            },
            child: Text("assign_user".tr),
          ),
        ],
      ),
    );

    if (resume == null || !resume) return;

    if (selectedDepartment == null || !hasChanged) {
      return;
    }

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("user_assigned".tr),
      ),
    );
    await DepartmentService().assignUserToDepartment(employee.id, selectedDepartment!.id);
  }

  Future removeUserFromDepartment(Employee employee) async {
    await FirebaseFirestore.instance.collection("users").doc(employee.id).update({"departmentId": ""});
  }
}
