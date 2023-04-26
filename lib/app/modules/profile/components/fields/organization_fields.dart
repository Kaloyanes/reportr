import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:reportr/app/modules/profile/controllers/profile_controller.dart';
import 'package:reportr/app/services/profile_service.dart';

class OrganizationFields extends StatelessWidget {
  const OrganizationFields({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Локация на организацията",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 150,
          child: StreamBuilder(
            stream: controller.locationLatLng.stream,
            initialData: controller.locationLatLng.value,
            builder: (context, snapshot) {
              return MapSwitcher(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    onMapCreated: (mapController) => controller.mapController = mapController,
                    onTap: (argument) => controller.pickLocation(),
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data ?? const LatLng(40, 20),
                      zoom: 17,
                    ),
                    mapToolbarEnabled: false,
                    liteModeEnabled: true,
                    mapType: MapType.hybrid,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(
          () => ListTile(
            title: const Text('Изберете цвят на организацията'),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 22,
              color: controller.organizationColor.value,
            ),
            onTap: () => controller.changeColor(),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          decoration: const InputDecoration(label: Text("Код за покана")),
          controller: controller.inviteController,
          readOnly: true,
          onChanged: (value) => controller.savedSettings.value = true,
        ),
        const SizedBox(
          height: 10,
        ),
        FilledButton(
          onPressed: () {
            controller.inviteController.text = ProfileService.createInviteCode(controller.nameController.text);
            controller.savedSettings.value = true;
          },
          child: const Text("Генерирай нов код"),
        ),
      ],
    );
  }
}
