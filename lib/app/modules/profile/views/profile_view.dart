import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
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
        body: Column(
          children: [
            profilePicture(),
          ],
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
}
