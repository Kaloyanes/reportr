import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:reportr/app/modules/home/components/drawer/drawer_component.dart';
import 'package:reportr/app/modules/home/components/report_sheet/views/report_sheet_view.dart';
import 'package:reportr/app/services/geo_service.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      extendBodyBehindAppBar: true,
      key: controller.scaffKey,
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
            alignment: const Alignment(-0.9, -0.9),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.scaffKey.currentState!.openDrawer(),
                  child: const Icon(
                    Icons.menu,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomSheet: const ReportSheetView(),
      floatingActionButton: Obx(
        () {
          return AnimatedSlide(
            curve: Curves.easeOutQuint,
            duration: const Duration(milliseconds: 600),
            offset: controller.showControls.value ? Offset.zero : const Offset(0, 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () => controller.goToMyLocation(),
                child: const Icon(Icons.navigation),
              ),
            ),
          );
        },
      ),
    );
  }
}
