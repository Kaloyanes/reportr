import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/profile/controllers/profile_controller.dart';
import 'package:reportr/app/services/profile_service.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
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
                      getInitials(snapshot.data!["name"]),
                      style: const TextStyle(fontSize: 60),
                    ),
                  );

                  if (data!["photoUrl"]?.isNotEmpty ?? false) {
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

  String getInitials(String name) {
    var initials = "";

    name.trim().split(" ").forEach((element) {
      initials += element[0];
    });

    return initials;
  }
}
