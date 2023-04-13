import 'package:get/get.dart';

import '../controllers/report_details_controller.dart';

class ReportDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportDetailsController>(
      () => ReportDetailsController(),
    );
  }
}
