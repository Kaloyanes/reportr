import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoService {
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

    var position = await Geolocator.getCurrentPosition();
    return Future.value(LatLng(position.latitude, position.longitude));
  }
}
