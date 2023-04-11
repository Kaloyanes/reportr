import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerControlller extends GetxController {
  final cameraPosition = const CameraPosition(target: LatLng(0, 0)).obs;

  // @override
  // void onInit() {
  //   getLocation();
  //   super.onInit();
  // }

  // Future getLocation() async {
  //   cameraPosition.value = CameraPosition(target: await GeoService().getLocation());
  // }

  Future<void> setLocation() async {
    inspect(cameraPosition.value.target);
    await Navigator.maybePop(Get.context!, cameraPosition.value.target);
  }
}
