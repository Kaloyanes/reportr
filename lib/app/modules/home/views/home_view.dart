import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_component.dart';
import 'package:reportr/app/services/geo_service.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ),
      );
    }

    return InnerDrawer(
      key: controller.innerDrawerKey,
      leftChild: const DrawerComponent(),
      onTapClose: true,
      colorTransitionChild: Colors.transparent,
      colorTransitionScaffold: Colors.transparent,
      velocity: 2,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 0),
          color: Theme.of(context).colorScheme.primary,
          blurRadius: 50,
          spreadRadius: 5,
        )
      ],
      offset: const IDOffset.only(left: 0.4),
      scale: const IDOffset.horizontal(0.8),
      proportionalChildArea: false,
      borderRadius: 50,
      leftAnimationType: InnerDrawerAnimation.static,
      swipe: false,
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      scaffold: content(context),
    );
  }

  Scaffold content(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: controller.scaffKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          FutureBuilder(
            future: GeoService().getLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: AlertDialog(
                    icon: const Icon(
                      Icons.warning,
                      size: 40,
                    ),
                    iconColor: Colors.red,
                    title: Text(
                      snapshot.error as String,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return MapSwitcher(
                child: Obx(
                  () => GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data ?? const LatLng(50, 50),
                      zoom: 15,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    compassEnabled: false,
                    onMapCreated: (GoogleMapController mapControl) async {
                      if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
                        var style = await rootBundle.loadString('lib/app/assets/darkMap.json');

                        mapControl.setMapStyle(style);
                      }
                      controller.mapController = mapControl;
                    },
                    markers: controller.markers.toSet(),
                    mapToolbarEnabled: false,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: const Alignment(-0.9, -0.85),
            child: Container(
              key: controller.drawerKey,
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.openDrawer(),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => AnimatedSlide(
          curve: Curves.easeOutQuint,
          duration: const Duration(milliseconds: 600),
          offset: controller.showControls.value ? Offset.zero : const Offset(0, 50),
          child: Container(
            key: controller.fabKey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => controller.goToMyLocation(),
              child: const Icon(Icons.navigation),
            ),
          ),
        ),
      ),
    );
  }
}
