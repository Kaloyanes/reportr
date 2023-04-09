import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/modules/home/components/report_sheet/controllers/report_sheet_controller.dart';

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
    print("COLOR: ${Colors.indigo[700]!.value}");
    super.onInit();
  }

  Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Локацията е спряна');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Не сте дали разрешение да се ползва локацията');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Не сте дали разрешение да се ползва локацията');
    }

    showControls.value = true;
    var position = await Geolocator.getCurrentPosition();
    return Future.value(LatLng(position.latitude, position.longitude));
  }

  Future<void> goToMyLocation() async {
    var position = await getLocation();

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ),
    );
  }

  Future getLocations() async {
    var collection = await FirebaseFirestore.instance.collection("users").get();

    var docs = collection.docs;

    for (var i = 0; i < docs.length; i++) {
      var doc = docs[i].data();
      var name = doc["name"] as String;
      var location = doc["location"] as GeoPoint;
      var color = Theme.of(Get.context!).colorScheme.primaryContainer;

      if (doc.containsKey("color")) color = Color(doc["color"]);

      var photo =
          await FirebaseStorage.instance.refFromURL(doc["photoUrl"]).getData();

      if (photo == null) continue;

      markers.add(
        Marker(
          icon: await convertImageFileToCustomBitmapDescriptor(
            photo,
            title: name,
            size: 150,
            titleBackgroundColor: color,
            addBorder: true,
            borderColor: color,
            borderSize: 20,
          ),
          markerId: MarkerId(name),
          position: LatLng(location.latitude, location.longitude),
          onTap: () => Get.find<ReportSheetController>().showReportForm(name),
        ),
      );
    }
  }

  Future<BitmapDescriptor> getCustomPin(
      Uint8List markerIcon, String name) async {
    ui.Image? picture;

    ui.decodeImageFromList(markerIcon, (result) {
      picture = result;
    });

    final TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.black),
      text: name,
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    canvas.drawImage(
      picture!,
      const Offset(0, 0),
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );
    tp.paint(canvas, const Offset(0, 100));
    final img = await pictureRecorder.endRecording().toImage(100, 150);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> convertImageFileToCustomBitmapDescriptor(
      Uint8List imageUint8List,
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
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
        const Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

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
            Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
            const Radius.circular(100)),
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
    textPainter.paint(
        canvas,
        Offset(radius - textPainter.width / 2,
            size * 9.5 / 10 - textPainter.height / 2));

    //convert canvas as PNG bytes
    final image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void openDrawer() => scaffKey.currentState!.openDrawer();
}
