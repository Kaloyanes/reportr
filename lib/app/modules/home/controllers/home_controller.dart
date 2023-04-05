import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  final showControls = false.obs;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  final Completer<LatLng> myLocation = Completer<LatLng>();

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

  void reloadApp() {
    Navigator.pushNamedAndRemoveUntil(Get.context!, '/', (_) => false);
  }

  Future<void> GoToMyLocation() async {
    var position = await getLocation();

    var cont = await mapController.future;

    cont.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position),
      ),
    );
  }
}
//dizajna na butona v tozi form li go pravish ili si go vzimash ot drugo mqsto kato class
