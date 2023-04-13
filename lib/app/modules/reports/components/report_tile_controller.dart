import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/models/report_model.dart';

class ReportTileController extends GetxController {
  final formatter = DateFormat("HH:mm:ss | dd/MM/yyyy ");

  Future<List<String>> getImages(Report report) async {
    var storage = FirebaseStorage.instance;

    var result = await storage.ref("reports/${report.id}").listAll();

    var photoLinks = <String>[];
    for (var pic in result.items) {
      photoLinks.add(await pic.getDownloadURL());
    }

    return photoLinks;
  }
}
