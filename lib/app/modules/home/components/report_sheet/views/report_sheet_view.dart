import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/home/components/report_sheet/controllers/report_sheet_controller.dart';

class ReportSheetView extends GetView<ReportSheetController> {
  const ReportSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportSheetController());
    return DraggableScrollableSheet(
      controller: controller.sheetController,
      expand: false,
      initialChildSize: 0.1,
      maxChildSize: 1,
      minChildSize: 0.1,
      builder: (context, scrollController) {
        return ReportForm(scrollController, context);
      },
    );
  }

  Padding ReportForm(ScrollController scrollController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
            Obx(() {
              String val = controller.selectedObject.value;

              if (val == "") {
                return Text(
                  "Цъкнете върху някое кръгче, за да докладвате",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                );
              }

              return Center(
                child: Text("Доклад към $val",
                    style: Theme.of(context).textTheme.headlineMedium),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      label: Text("Името на доклада"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      label: Text("Описание на доклада"),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => SwitchListTile(
                      title: const Text(
                        "Анонимно докладаване?",
                      ),
                      value: controller.anonReport.value,
                      onChanged: (value) => controller.anonReport.value =
                          !controller.anonReport.value,
                      selected: controller.anonReport.value,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          onTap: () => controller.addPhoto(),
                          child: const SizedBox(
                            width: 200,
                            height: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text("Добави снимка"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Card(
                      elevation: 3,
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
            FilledButton.tonalIcon(
              onPressed: () => controller.report(),
              label: const Text("Докладвай"),
              icon: const Icon(Icons.report),
            ),
            SizedBox(
              height: Get.mediaQuery.systemGestureInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
