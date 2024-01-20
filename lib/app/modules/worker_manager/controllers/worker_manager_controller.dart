import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/models/employee_model.dart';

class WorkerManagerController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    employeeStream.listen((event) {
      for (var element in event.docs) {
        var data = element.data();

        data.addAll({"id": element.id});

        employees.add(Employee.fromMap(data));
      }

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
    var name = TextEditingController();
    var type = TextEditingController();

    await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("create_department".tr),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
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
              TextFormField(
                controller: type,
                decoration: InputDecoration(
                  labelText: "type".tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "fill_field".tr;
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          FilledButton(
            onPressed: () => Get.back(),
            child: Text("create".tr),
          ),
        ],
      ),
    );

    var ownerId = FirebaseAuth.instance.currentUser!.uid;

    // TODO: Create department
  }
}
