import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/profile/components/fields/organization_fields.dart';
import 'package:reportr/app/modules/profile/views/image_crop_view.dart';
import 'package:reportr/app/modules/sign_up/views/location_picker_view.dart';
import 'package:reportr/app/routes/app_pages.dart';
import "package:path/path.dart" as p;

class ProfileController extends GetxController {
  late GoogleMapController mapController;

  final savedSettings = false.obs;

  final deletePhoto = false.obs;
  set delPhoto(bool val) => deletePhoto.value = val;

  Rx<XFile> photo = XFile("").obs;
  set setPhoto(XFile val) => photo.value = val;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final store = FirebaseFirestore.instance;

  final Rx<Widget> roleChild = Container().obs;

  Future<bool> exitPage() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (!savedSettings.value) return Future.value(true);

    return await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning, size: 30),
        title: const Text("Сигурни ли сте, че не искате да запазите промените?"),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context, true);
            },
            child: const Text("Да"),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context, false);
            },
            child: const Text("Не"),
          ),
        ],
      ),
    );
  }

  Future<void> selectPhoto() async {
    HapticFeedback.selectionClick();

    var imageSource = await showDialog<String>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Изберете действие"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Камера"),
              leading: const Icon(
                Icons.camera_alt,
              ),
              onTap: () => Get.back(result: "camera"),
            ),
            ListTile(
              title: const Text("Галерия"),
              leading: const Icon(
                Icons.photo,
              ),
              onTap: () => Get.back(result: "gallery"),
            ),
            ListTile(
              title: const Text("Изтрий снимката"),
              leading: const Icon(
                Icons.delete,
              ),
              onTap: () => Get.back(result: "delete"),
            ),
          ],
        ),
      ),
    );

    if (imageSource == null) return;

    if (imageSource == "delete") {
      delPhoto = true;
      return;
    }

    _capture(imageSource == "camera" ? ImageSource.camera : ImageSource.gallery);
  }

  Future<void> _capture(ImageSource source) async {
    var selectedPhoto = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 99,
    );

    if (selectedPhoto != null) {
      HapticFeedback.lightImpact();
      var photoData = await Get.to<Uint8List>(
        ImageCropView(imageData: await selectedPhoto.readAsBytes()),
        preventDuplicates: true,
      );

      if (photoData == null) return;
      savedSettings.value = true;

      var path = selectedPhoto.path;
      var savePhoto = XFile.fromData(photoData);

      await savePhoto.saveTo(path);

      savePhoto = XFile(path);
      setPhoto = savePhoto;
    }
  }

  Future<void> savePhoto() async {
    HapticFeedback.selectionClick();

    var file = File(photo.value.path);
    if (!file.existsSync()) return;

    var ext = p.extension(photo.value.path);

    try {
      final ref = storage.ref("/profile_pictures/${auth.currentUser!.uid}$ext");

      var task = ref.putFile(file);

      task.whenComplete(() async {
        var url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection("users").doc(auth.currentUser?.uid).update({"photoUrl": url});
      });
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") return;

      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> deletePhotoSetting() async {
    var doc = store.collection("users").doc(auth.currentUser?.uid);
    var getDoc = await doc.get();

    if (getDoc.data()!.containsKey("photoUrl")) {
      setPhoto = XFile("");
      await store.collection("users").doc(auth.currentUser?.uid).update({
        "photoUrl": "",
      });
    }
  }

  Future<void> saveSettings() async {
    FocusScope.of(Get.context!).unfocus();

    await saveInfo();
    if (deletePhoto.value) {
      await deletePhotoSetting();
    } else {
      await savePhoto();
    }

    savedSettings.value = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Запазени са промените"),
      ),
    );
  }

  @override
  void onClose() {
    setPhoto = XFile("");
    savedSettings.value = false;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  final nameController = TextEditingController();
  final inviteController = TextEditingController();
  final emailController = TextEditingController();
  final role = "".obs;
  final organizationColor = const Color.fromARGB(255, 247, 84, 84).obs;
  final locationLatLng = const LatLng(0, 0).obs;

  Future<void> getInfo() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid).get();

    var data = doc.data();

    nameController.text = data!["name"];
    emailController.text = data["email"];
    role.value = data["role"];
    locationLatLng.value = data["role"] == "organization"
        ? LatLng((data["locationCord"] as GeoPoint).latitude, (data["locationCord"] as GeoPoint).longitude)
        : const LatLng(0, 0);

    inviteController.text = data["role"] != "reporter" ? data["inviteCode"] : "";
    if (role.value == "organization") {
      organizationColor.value = Color(data["organizationColor"]);
      roleChild.value = Container(child: OrganizationFields(controller: Get.find<ProfileController>()));
    }

    setListeners();
  }

  void setListeners() {
    locationLatLng.stream.listen((event) {
      savedSettings.value = true;
    });

    organizationColor.stream.listen((event) {
      savedSettings.value = true;
    });
  }

  Future<void> saveInfo() async {
    var doc = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid);

    var data = <String, dynamic>{
      "name": nameController.text.trim(),
      "inviteCode": inviteController.text.trim(),
    };

    data.addAllIf(role.value == "organization", {
      "locationCord": GeoPoint(locationLatLng.value.latitude, locationLatLng.value.longitude),
      "organizationColor": organizationColor.value.value,
    });

    var email = emailController.text.trim();
    if (email != auth.currentUser!.email) {
      data.addAll({"email": email});
      await auth.currentUser!.updateEmail(email);
    }

    await doc.update(data);
  }

  Future<void> forgotPassword() async {
    await auth.sendPasswordResetEmail(email: auth.currentUser!.email ?? "");

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        content: Text(
          "Погледнете си имейла",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> deleteProfile() async {
    var shouldDelete = await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
          size: 30,
        ),
        title: const Text("Сигурни ли сте, че искате да си изтрийте профила?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Да"),
          ),
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Не"),
          )
        ],
      ),
    );

    if (!shouldDelete) return;

    var uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
    await FirebaseFirestore.instance.collection("locations").doc(uid).delete();
    var chats = await FirebaseFirestore.instance.collection("chats").get();

    for (var chat in chats.docs) {
      if (chat.id.contains(uid)) {
        await FirebaseFirestore.instance.collection("chats").doc(chat.id).delete();
      }
    }
    await FirebaseAuth.instance.currentUser!.delete();
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> pickLocation() async {
    var location = await Get.to<LatLng>(LocationPickerView(
      location: locationLatLng.value,
    ));

    if (location == null) return;

    print(location);
    locationLatLng.value = location;
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
        okButton: false,
        closeButton: false,
        dialogActionButtons: true,
        dialogCancelButtonLabel: "Отказ",
      ),
      // constraints: const BoxConstraints(minHeight: 480, minWidth: 320, maxWidth: 320),
    );

    organizationColor.value = newColor;
  }
}
