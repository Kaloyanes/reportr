import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsContoller> {
  const ReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportsContoller());
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: controller.getStream(),
        builder: (context, snapshot) {
          return StreamBuilder(
            stream: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(docs[index]["title"]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
