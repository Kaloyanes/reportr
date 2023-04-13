import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/modules/reports/components/report_tile.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsContoller> {
  const ReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportsContoller());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Доклади"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(
          () => StreamBuilder(
            stream: controller.stream.value,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var docs = snapshot.data!.docs;

              return RefreshIndicator(
                onRefresh: () => controller.refreshList(),
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    mainAxisExtent: 400,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var report = Report.fromMap(docs[index].data(), docs[index].id);
                    return ReportTile(report: report);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
