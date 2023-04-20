import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/reports/components/filter_drawer/filter_drawer.dart';
import 'package:reportr/app/modules/reports/components/report_tile.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsContoller> {
  const ReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportsContoller());
    return Scaffold(
      key: controller.scaffKey,
      endDrawer: const FilterDrawer(),
      appBar: AppBar(
        title: const Text("Доклади"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Най-скорошни"),
                onTap: () => controller.sort("date"),
              ),
              PopupMenuItem(
                child: const Text("Най-приоритетни"),
                onTap: () => controller.sort("rating"),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () => controller.scaffKey.currentState!.openEndDrawer(),
            icon: const Icon(Icons.filter_alt),
          ),
        ],
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
                    // mainAxisExtent: 440,
                    childAspectRatio: 9 / 22,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var report = Report.fromMap(docs[index].data(), docs[index].id);

                    if (report.reporterId == "anon") {
                      return ReportTile(
                        report: report,
                        reporter: Reporter.anon(),
                      );
                    }

                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection("users").doc(report.reporterId).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var reporter = Reporter.fromMap(snapshot.data!.data()!, snapshot.data!.id);

                        return ReportTile(
                          report: report,
                          reporter: reporter,
                        );
                      },
                    );
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
