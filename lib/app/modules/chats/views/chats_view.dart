import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:reportr/app/components/back_button.dart';
import 'package:reportr/app/models/reporter_model.dart';

import '../controllers/chats_controller.dart';
import 'chat_view.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chats'.tr),
        centerTitle: true,
        leading: const CustomBackButton(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats").orderBy("lastMessage", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = snapshot.data!.docs.where(
            (element) => element.id.contains(FirebaseAuth.instance.currentUser!.uid),
          );

          if (user.isEmpty) {
            return Center(
              child: Text(
                "Няма чатове",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ).animate(delay: 500.ms).scaleXY(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: 600.ms,
                );
          }

          return ListView(
            children: [
              for (var i = 0; i < user.length; i++)
                Builder(
                  builder: (context) {
                    var doc = user.elementAt(i);

                    var ids = doc.id.split(".");
                    var otherPersonids = ids[0] == FirebaseAuth.instance.currentUser!.uid ? ids[1] : ids[0];

                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(otherPersonids).get(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        var personData = snapshot.data!.data() ?? {};

                        if (personData.isEmpty) {
                          return Container();
                        }

                        personData.addAll({"uid": otherPersonids});
                        String initials = "";

                        personData["name"].toString().trim().split(' ').forEach((element) {
                          initials += element[0];
                        });

                        var reporter = Reporter.fromMap(personData, snapshot.data!.id);

                        return ListTile(
                          leading: CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(reporter.photoUrl),
                            child: Text(initials),
                          ),
                          title: Text(
                            personData["name"],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          onTap: () async {
                            Get.to(
                              () => const ChatView(),
                              arguments: {
                                "reporter": reporter,
                                "docId": doc.id,
                                "initials": initials,
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                )
            ]
                .animate(
                  interval: 100.ms,
                )
                .slideX(
                  curve: Curves.easeOutQuint,
                  begin: 2,
                  duration: 1000.ms,
                )
                .blurX(
                  begin: 5,
                  end: 0,
                  // curve: Curves.easeInOutExpo,
                  curve: Curves.easeOutQuart,
                  duration: 600.ms,
                  delay: 200.ms,
                ),
          );
        },
      ),
    );
  }
}
