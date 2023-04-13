import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/report_model.dart';

class ReportDetailsController extends GetxController {
  final Report report = Get.arguments["report"];
  final List<String> photos = Get.arguments["images"];

  final formatter = DateFormat("HH:mm:ss\ndd/MM/yyyy ");

  final pageController = PageController();
}
