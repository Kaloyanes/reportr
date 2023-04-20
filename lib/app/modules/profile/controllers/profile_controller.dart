import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportr/app/modules/profile/views/image_crop_view.dart';
import 'package:reportr/app/routes/app_pages.dart';
import "package:path/path.dart" as p;

class ProfileController extends GetxController {
  // final savedSettings = false.obs;

  // set setSavedSettings(bool val) => savedSettings.value = val;

  // final deletePhoto = false.obs;

  // set delPhoto(bool val) => deletePhoto.value = val;

  // Rx<XFile> photo = XFile("").obs;

  // set setPhoto(XFile val) => photo.value = val;

  // Future<bool> exitPage() async {
  //   FocusScope.of(Get.context!).requestFocus(FocusNode());
  //   if (!savedSettings.value) return Future.value(true);

  //   return await showDialog(
  //     context: Get.context!,
  //     builder: (context) => AlertDialog(
  //       icon: const Icon(Icons.warning, size: 30),
  //       title: const Text("Сигурни ли сте, че не искате да запазите промените?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             HapticFeedback.lightImpact();
  //             Navigator.pop(context, true);
  //           },
  //           child: const Text("Да"),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             HapticFeedback.lightImpact();
  //             Navigator.pop(context, false);
  //           },
  //           child: const Text("Не"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> selectPhoto() async {
  //   HapticFeedback.selectionClick();

  //   var imageSource = await showModalBottomSheet<String>(
  //     context: Get.context!,
  //     builder: (context) => const PhotoBottomSheet(),
  //     isScrollControlled: true,
  //   );

  //   if (imageSource == null) return;

  //   if (imageSource == "delete") {
  //     delPhoto = true;
  //     return;
  //   }

  //   _capture(imageSource == "camera" ? ImageSource.camera : ImageSource.gallery);
  // }

  // Future<void> _capture(ImageSource source) async {
  //   var selectedPhoto = await _picker.pickImage(
  //     source: source,
  //     preferredCameraDevice: CameraDevice.front,
  //     imageQuality: 99,
  //   );

  //   if (selectedPhoto != null) {
  //     HapticFeedback.lightImpact();
  //     var photoData = await Get.to<Uint8List>(
  //       ImageCropView(imageData: await selectedPhoto.readAsBytes()),
  //       preventDuplicates: true,
  //     );

  //     if (photoData == null) return;
  //     setSavedSettings = true;

  //     var path = selectedPhoto.path;
  //     var savePhoto = XFile.fromData(photoData);

  //     await savePhoto.saveTo(path);

  //     savePhoto = XFile(path);
  //     setPhoto = savePhoto;
  //   }
  // }

  // Future<void> savePhoto() async {
  //   HapticFeedback.selectionClick();

  //   var file = File(photo.value.path);
  //   if (!file.existsSync()) return;

  //   var ext = p.extension(photo.value.path);

  //   try {
  //     final ref = storage.ref("/profile_pictures/${auth.currentUser!.uid}$ext");

  //     var task = ref.putFile(file);

  //     task.whenComplete(() async {
  //       var url = await ref.getDownloadURL();
  //       await FirebaseFirestore.instance.collection("users").doc(auth.currentUser?.uid).update({"photoUrl": url});
  //     });
  //   } on FirebaseException catch (e) {
  //     if (e.code == "object-not-found") return;

  //     showDialog(
  //       context: Get.context!,
  //       builder: (context) => AlertDialog(
  //         icon: const Icon(Icons.warning),
  //         content: Text(
  //           e.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<void> deletePhotoSetting() async {
  //   var doc = store.collection("users").doc(auth.currentUser?.uid);
  //   var getDoc = await doc.get();

  //   if (getDoc.data()!.containsKey("photoUrl")) {
  //     setPhoto = XFile("");
  //     await store.collection("users").doc(auth.currentUser?.uid).update({
  //       "photoUrl": "",
  //     });
  //   }
  // }

  // Future<void> saveSettings() async {
  //   await saveInfo();
  //   if (deletePhoto.value) {
  //     await deletePhotoSetting();
  //   } else {
  //     await savePhoto();
  //   }

  //   setSavedSettings = false;
  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
  //     const SnackBar(
  //       content: Text("Запазени са промените"),
  //     ),
  //   );
  // }

  // @override
  // void onClose() {
  //   setPhoto = XFile("");
  //   setSavedSettings = false;
  //   super.onClose();
  // }

  // Future<void> saveInfo() async {
  //   var doc = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid);

  //   var data = {
  //     "name": displayNameController.text.trim().capitalize,
  //     "description": descriptionController.text.trim(),
  //     "showProfile": showProfile.value,
  //     "subjects": subjects
  //   };

  //   data.addIf(role.value == "student", "badSubjects", badSubjects);

  //   data.addIf(phoneController.text.trim().isNotEmpty, "phone", "+359${phoneController.text.trim()}");

  //   var email = emailController.text.trim();
  //   if (email != auth.currentUser!.email) {
  //     data.addAll({"email": email});
  //     await auth.currentUser!.updateEmail(email);
  //   }

  //   var locationDoc = store.collection("locations").doc(auth.currentUser!.uid);

  //   if ((await locationDoc.get()).exists) {
  //     locationDoc.update({
  //       "show": showProfile.value,
  //     });
  //   }

  //   doc.update(data);
  // }

  final savedSettings = false.obs;

  set setSavedSettings(bool val) => savedSettings.value = val;

  final deletePhoto = false.obs;

  set delPhoto(bool val) => deletePhoto.value = val;

  Rx<XFile> photo = XFile("").obs;

  set setPhoto(XFile val) => photo.value = val;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final store = FirebaseFirestore.instance;

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
      setSavedSettings = true;

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
    // await saveInfo();
    if (deletePhoto.value) {
      await deletePhotoSetting();
    } else {
      await savePhoto();
    }

    setSavedSettings = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Запазени са промените"),
      ),
    );
  }

  @override
  void onClose() {
    setPhoto = XFile("");
    setSavedSettings = false;
    super.onClose();
  }

  bool _ignoreSubject = true;
  bool _ignoreBad = true;

  @override
  void onInit() {
    super.onInit();
    getInfo();

    subjects.listen((p0) {
      if (!_ignoreSubject) {
        setSavedSettings = true;
      }
      _ignoreSubject = false;
    });
    badSubjects.listen((p0) {
      if (!_ignoreBad) {
        setSavedSettings = true;
      }
      _ignoreBad = false;
    });
  }

  final showRoleSettings = false.obs;

  final displayNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final role = "".obs;
  final subjectController = TextEditingController();
  final badSubjectController = TextEditingController();
  final showProfile = false.obs;

  final subjects = <String>[].obs;

  set addSubject(String val) {
    subjects.add(val.trim().capitalizeFirst!);
  }

  final badSubjects = <String>[].obs;

  set addbadSubject(String val) {
    badSubjects.add(val.trim().capitalizeFirst!);
  }

  final Rx<LatLng?> currentLocation = null.obs;

  Future<void> getInfo() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid).get();

    var data = doc.data();

    displayNameController.text = data!["name"];
    descriptionController.text = data["description"] ?? "";
    phoneController.text = data.containsKey("phone") ? (data["phone"] as String).substring(4) : "";
    emailController.text = data["email"];
    role.value = data["role"];
    showProfile.value = data["showProfile"] as bool;
    subjects.value = List.castFrom<dynamic, String>(data["subjects"] as List<dynamic>);

    if (data.containsKey("badSubjects")) {
      badSubjects.value = List.castFrom<dynamic, String>(data["badSubjects"] as List<dynamic>);
    }
    showRoleSettings.value = true;

    var locDoc = await FirebaseFirestore.instance.collection("locations").doc(auth.currentUser!.uid).get();

    var locationData = locDoc.data() ?? {};

    if (locationData.containsKey("position")) {
      var geo = locationData["position"] as GeoPoint;

      currentLocation.value = LatLng(geo.latitude, geo.longitude);
    }
  }

  Future<void> saveInfo() async {
    var doc = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid);

    var data = {
      "name": displayNameController.text.trim().capitalize,
      "description": descriptionController.text.trim(),
      "showProfile": showProfile.value,
      "subjects": subjects
    };

    data.addIf(role.value == "student", "badSubjects", badSubjects);

    data.addIf(phoneController.text.trim().isNotEmpty, "phone", "+359${phoneController.text.trim()}");

    var email = emailController.text.trim();
    if (email != auth.currentUser!.email) {
      data.addAll({"email": email});
      await auth.currentUser!.updateEmail(email);
    }

    var locationDoc = store.collection("locations").doc(auth.currentUser!.uid);

    if ((await locationDoc.get()).exists) {
      locationDoc.update({
        "show": showProfile.value,
      });
    }

    doc.update(data);
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

  Future<void> updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition();

    var locationDoc = store.collection("locations").doc(auth.currentUser!.uid);

    locationDoc.set({
      "place": GeoPoint(position.latitude, position.longitude),
      "show": showProfile.value,
    });

    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Подновихте си локацията")));
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
}
