import 'package:get/get.dart';

import '../controllers/worker_manager_controller.dart';

class WorkerManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerManagerController>(
      () => WorkerManagerController(),
    );
  }
}
