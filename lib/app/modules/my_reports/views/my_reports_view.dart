import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_reports_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyReportsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyReportsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
