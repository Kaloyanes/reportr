import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/modules/home/components/report_sheet/controllers/report_sheet_controller.dart';
import 'package:reportr/app/services/geo_service.dart';

class HomeController extends GetxController {
  final scaffKey = GlobalKey<ScaffoldState>();
  GlobalKey sta = GlobalKey();

  final sheetController = DraggableScrollableController();
  final markers = <Marker>{}.obs;

  final showControls = false.obs;

  late GoogleMapController mapController;
  var scrollController = ScrollController();

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  Future<void> goToMyLocation() async {
    var position = await GeoService().getLocation();

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ),
    );
  }

  Future getLocations() async {
    var collection = await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "organization")
        .where("photoUrl", isNull: false)
        .get();

    var docs = collection.docs;

    inspect(docs);
    for (var i = 0; i < docs.length; i++) {
      var doc = docs[i].data();
      var name = doc["name"] as String;
      var location = doc["locationCord"] as GeoPoint;
      var color = Theme.of(Get.context!).colorScheme.primaryContainer;

      if (doc.containsKey("color")) color = Color(doc["color"]);

      var photo = await FirebaseStorage.instance.refFromURL(doc["photoUrl"]).getData();

      if (photo == null) continue;

      markers.add(
        Marker(
          icon: await convertImageFileToCustomBitmapDescriptor(
            photo,
            title: name,
            size: 130,
            titleBackgroundColor: color,
            addBorder: true,
            borderColor: color,
            borderSize: 20,
          ),
          markerId: MarkerId(docs[i].id),
          position: LatLng(location.latitude, location.longitude),
          onTap: () => Get.find<ReportSheetController>().showReportForm(name, docs[i].id),
        ),
      );
    }
    showControls.value = true;
  }

  Future<BitmapDescriptor> convertImageFileToCustomBitmapDescriptor(Uint8List imageUint8List,
      {int size = 150,
      bool addBorder = false,
      Color borderColor = Colors.white,
      double borderSize = 10,
      required String title,
      Color titleColor = Colors.white,
      Color titleBackgroundColor = Colors.black}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), const Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10), const Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    // if (title.split(" ").length > 1) {
    //   title = title.split(" ")[0];
    // }

    paint
      ..color = titleBackgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10), const Radius.circular(100)),
        paint);

    //draw Title
    textPainter.text = TextSpan(
        text: title,
        style: TextStyle(
          fontSize: radius / 2.5,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(radius - textPainter.width / 2, size * 9.5 / 10 - textPainter.height / 2));

    //convert canvas as PNG bytes
    final image = await pictureRecorder.endRecording().toImage(size, (size * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void openDrawer() => scaffKey.currentState!.openDrawer();
}
