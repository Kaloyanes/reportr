import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/modules/sign_up/views/location_picker_view.dart';
import 'package:reportr/app/services/auth_service.dart';
import 'package:reportr/app/services/geo_service.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final isOrganization = false.obs;

  late GoogleMapController mapController;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationPicked = const LatLng(40, 20).obs;
  final organizationColor = const Color.fromARGB(255, 255, 0, 0).obs;

  final hidePassword = true.obs;

  final Rx<Widget> optionalFields = Container(
    child: const Column(
      children: [
        Text("Докладващ"),
      ],
    ),
  ).obs;

  @override
  void onInit() {
    setLocation();
    super.onInit();
  }

  Future setLocation() async {
    locationPicked.value = await GeoService().getLocation();
  }

  Future register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await AuthService().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        isOrganisation: isOrganization.value,
        locationCord: locationPicked.value,
        organizationColor: organizationColor.value,
        role: isOrganization.value ? "organization" : "user",
      );
    } on FirebaseException catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: Text(e.message!),
        ),
      );

      return;
    }

    Navigator.maybePop(Get.context!);
    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Успешно регистриран профил")));
  }

  Future<void> pickLocation() async {
    var location = await Get.to<LatLng>(LocationPickerView(
      location: locationPicked.value,
    ));

    if (location == null) return;

    print(location);
    locationPicked.value = location;
    mapController.moveCamera(CameraUpdate.newLatLng(location));
  }

  Future changeColor() async {
    // Wait for the dialog to return backgroundColor selection result.
    final Color newColor = await showColorPickerDialog(
      Get.context!,
      organizationColor.value,
      title: Text('Цвят на организацията', style: Theme.of(Get.context!).textTheme.titleLarge),
      width: 50,
      height: 40,
      spacing: 0,
      runSpacing: 0,
      borderRadius: 0,
      wheelDiameter: 165,
      enableOpacity: false,
      showColorCode: false,
      colorCodeHasColor: true,
      pickersEnabled: <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
        ColorPickerType.accent: false,
        ColorPickerType.primary: false,
      },
      showRecentColors: false,
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: true,
      ),
      // constraints: const BoxConstraints(minHeight: 480, minWidth: 320, maxWidth: 320),
    );

    organizationColor.value = newColor;
  }
}
