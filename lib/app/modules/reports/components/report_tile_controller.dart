import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/report_model.dart';

class ReportTileController extends GetxController {
  final formatter = DateFormat("dd/MM/yyyy ");

  Future<String> getFirstImage(Report report) async {
    var storage = FirebaseStorage.instance;

    var result = await storage.ref("reports/${report.id}").listAll();

    return await result.items[0].getDownloadURL();
  }
}
