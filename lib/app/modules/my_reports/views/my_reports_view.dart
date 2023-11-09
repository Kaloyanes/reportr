import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/reports/components/report_tile.dart';

import '../controllers/my_reports_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("my_reports".tr),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("reports")
              .where("reporterId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: Text(
                  "no_reports".tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ).animate(delay: 500.ms).scaleXY(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: 600.ms,
                  );
            }

            return GridView.builder(
              cacheExtent: 1000,
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
                      sender: true,
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
