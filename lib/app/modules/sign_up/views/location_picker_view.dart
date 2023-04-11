import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:reportr/app/modules/sign_up/controllers/location_picker_controller.dart';

class LocationPickerView extends GetView<LocationPickerControlller> {
  const LocationPickerView({super.key, this.location});

  final LatLng? location;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LocationPickerControlller());
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          MapSwitcher(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: location ?? const LatLng(0, 0),
                zoom: 15,
              ),
              onCameraMove: (position) => controller.cameraPosition.value = position,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              mapType: MapType.hybrid,
            ),
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 50,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.setLocation(),
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
