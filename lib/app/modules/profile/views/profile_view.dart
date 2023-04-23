import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:reportr/app/services/profile_service.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());
    return WillPopScope(
      onWillPop: () => controller.exitPage(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профил'),
          centerTitle: true,
        ),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              profilePicture(),
              TextFormField(
                controller: controller.nameController,
              ),
              TextFormField(
                controller: controller.emailController,
              ),
              TextFormField(
                controller: controller.inviteController,
              ),
              AnimatedSize(
                duration: 500.ms,
              )
            ],
          ),
        ),
        floatingActionButton: Obx(
          () => FloatingActionButton(
            elevation: 3,
            onPressed: () => controller.saveSettings(),
            heroTag: "saveButton",
            child: const Icon(Icons.save),
          )
              .animate(
                target: controller.savedSettings.value ? 1 : 0,
              )
              .scaleXY(
                curve: Curves.easeOutCubic,
                duration: 400.ms,
                // delay: 150.ms,
                begin: -0.5,
                end: 1,
              )
              .slideY(
                end: 0,
                begin: 5,
                curve: Curves.easeOutCubic,
                duration: 400.ms,
              )
              .then()
              .blurXY(
                begin: 3,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOut,
              ),
        ),
      ),
    );
  }

  Widget profilePicture() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      clipBehavior: Clip.antiAlias,
      children: [
        Align(
          alignment: Alignment.center,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) => FutureBuilder(
              future: ProfileService().getProfileInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.hasError) {
                  return const CircularProgressIndicator();
                }

                return Obx(() {
                  if (controller.photo.value.path != "") {
                    return CircleAvatar(
                      radius: 100,
                      foregroundImage: FileImage(
                        File(controller.photo.value.path),
                      ),
                    );
                  }

                  var data = snapshot.data;

                  Widget child = CircleAvatar(
                    radius: 100,
                    child: Text(
                      data!["initials"] ?? "",
                      style: const TextStyle(fontSize: 60),
                    ),
                  );

                  if (data["photoUrl"]?.isNotEmpty ?? false) {
                    child = CircleAvatar(
                      radius: 100,
                      foregroundImage: CachedNetworkImageProvider(data["photoUrl"] ?? ""),
                    );
                  }

                  return child;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(Get.context!).size.height / 4.5,
          width: 212,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).scaffoldBackgroundColor.withAlpha(100),
                borderRadius: BorderRadius.circular(360),
              ),
              child: IconButton(
                onPressed: () => controller.selectPhoto(),
                icon: const Icon(Icons.add_a_photo),
                iconSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column organizationFields(BuildContext context) {
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
      ],
    );
  }
}
