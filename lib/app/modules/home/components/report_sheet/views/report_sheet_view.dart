import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/home/components/report_sheet/controllers/report_sheet_controller.dart';

class ReportSheetView extends GetView<ReportSheetController> {
  const ReportSheetView(this.name, this.id, {super.key});

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportSheetController(id));

    return DraggableScrollableSheet(
      controller: controller.sheetController,
      expand: false,
      initialChildSize: 0,
      maxChildSize: 1,
      minChildSize: 0,
      builder: (context, scrollController) => Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(
                height: Get.mediaQuery.viewPadding.top + 10,
              ),
              Container(
                width: 150,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white30,
                ),
              ),
              SizedBox(
                height: Get.mediaQuery.viewPadding.top - 10,
              ),
              Center(
                child: Text(
                    "report_to".trParams(
                      {
                        "organization": name,
                      },
                    ),
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    TextFormField(
                      onTap: () {
                        Timer(const Duration(milliseconds: 400), () {
                          scrollController.animateTo(
                            0.4,
                            duration: 600.milliseconds,
                            curve: Curves.easeInOutCubicEmphasized,
                          );
                        });
                      },
                      autofocus: false,
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        label: Text("report_name".tr),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedPhotos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.selectedPhotos.length) {
                        return Card(
                          elevation: 3,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            onTap: () => controller.addPhoto(),
                            child: SizedBox(
                              width: 200,
                              height: 100,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.add_a_photo),
                                    Text("add_picture".tr),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Card(
                        elevation: 3,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onLongPress: () => controller.photoSettings(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(
                                controller.selectedPhotos[index].path,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: FocusScope(
                  onFocusChange: (value) {
                    if (value) {
                      Timer(const Duration(milliseconds: 240), () {
                        scrollController.animateTo(
                          scrollController.positions.last.maxScrollExtent,
                          duration: 600.milliseconds,
                          curve: Curves.easeInOutCubicEmphasized,
                        );
                      });
                    }
                  },
                  child: TextFormField(
                    autofocus: false,
                    controller: controller.descriptionController,
                    decoration: InputDecoration(
                      label: Text("report_description".tr),
                    ),
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "fill_field".tr;
                      }

                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                initialData: FirebaseAuth.instance.currentUser,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => CheckboxListTile(
                        title: Text(
                          "anonymous_report".tr,
                        ),
                        value: controller.anonReport.value,
                        onChanged: (value) => controller.anonReport.value = !controller.anonReport.value,
                        selected: !controller.anonReport.value,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton.tonalIcon(
                onPressed: () => controller.report(),
                label: Text("report".tr),
                icon: const Icon(Icons.report),
              ),
              SizedBox(
                height: Get.mediaQuery.viewInsets.bottom + 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
