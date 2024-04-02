import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/models/employee_model.dart';
import 'package:reportr/app/modules/worker_manager/components/add_department_dialog.dart';
import 'package:reportr/app/modules/worker_manager/components/confirm_dialog.dart';
import 'package:reportr/app/modules/worker_manager/components/department_dialog.dart';
import 'package:reportr/app/services/department_service.dart';

class WorkerManagerController extends GetxController
    with GetSingleTickerProviderStateMixin {
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

  Future<void> removeUser(Employee employee) async {
    var confirm = await showDialog<bool?>(
      context: Get.context!,
      builder: (context) => ConfirmDialog(
        title: "remove_user_from_organization".trParams({
          "employee": employee.name,
        }),
      ),
    );

    HapticFeedback.selectionClick();
    if (confirm == null || !confirm) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(employee.id)
        .update({"organization": "", "inviteCode": "", "departmentId": ""});
  }

  Future<void> addNewDepartment() async {
    var nameController = TextEditingController();
    var descriptionController = TextEditingController();

    await showDialog(
      context: Get.context!,
      builder: (context) => AddDepartmentDialog(
        nameController: nameController,
        descriptionController: descriptionController,
      ),
    );

    if (nameController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      return;
    }

    await DepartmentService().createDepartment(
        nameController.text.trim(), descriptionController.text.trim());
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("department_created".trParams({
          "department": nameController.text.trim(),
        })),
      ),
    );
  }

  Future<void> removeDepartment() async {
    if (departments.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("no_departments".tr),
        ),
      );

      return;
    }

    var selectedDepartment = await showDialog<Department?>(
      useSafeArea: true,
      context: Get.context!,
      builder: (context) => DepartmentDialog(
          title: "remove_department".tr, departments: departments),
    );

    HapticFeedback.selectionClick();

    if (selectedDepartment == null) return;

    // confirm dialog
    var confirm = await showDialog<bool>(
        useSafeArea: true,
        context: Get.context!,
        builder: (context) => ConfirmDialog(
              title: "remove_department".tr,
              message: "remove_department_confirm"
                  .trParams({"department": selectedDepartment.name}),
            ));

    HapticFeedback.selectionClick();
    if (confirm == null || !confirm) return;

    await DepartmentService().deleteDepartment(selectedDepartment.id);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("department_removed".trParams({
          "department": selectedDepartment.name,
        })),
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

    var selectedDepartment = await showDialog<Department?>(
        useSafeArea: true,
        context: Get.context!,
        builder: (context) => DepartmentDialog(
            title: "assign_user".tr, departments: departments));

    if (selectedDepartment == null) {
      return;
    }

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("user_assigned".tr),
      ),
    );
    await DepartmentService()
        .assignUserToDepartment(employee.id, selectedDepartment!.id);
  }

  Future<void> removeUserFromDepartment(Employee employee) async {
    var department = departments
        .firstWhereOrNull((element) => element.id == employee.departmentId);
    printInfo(info: "employee: ${employee.departmentId}");
    printInfo(
        info:
            "${departments.map((element) => "${element.name}: (${element.id})")}");
    var confirm = await showDialog<bool?>(
      context: Get.context!,
      builder: (context) => ConfirmDialog(
        title: "remove_user_from_department_question".trParams({
          "department": department!.name,
          "employee": employee.name,
        }),
      ),
    );

    HapticFeedback.selectionClick();
    if (confirm == null || !confirm) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(employee.id)
        .update({"departmentId": ""});
  }
}
