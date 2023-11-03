import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/chats/components/chat_bottom_bar.dart';
import 'package:reportr/app/modules/chats/components/messages/chat_message.dart';
import 'package:reportr/app/modules/chats/components/messages/file_message.dart';
import 'package:reportr/app/modules/chats/components/messages/image_message.dart';
import 'package:reportr/app/modules/chats/controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => ChatController(),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(controller.reporter.photoUrl),
              child: Text(controller.initials),
            ),
            const SizedBox(width: 10),
            Text(
              controller.reporter.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 8,
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  var item = controller.messages.reversed.elementAt(index);
                  bool isOwnMessage = item.sender == FirebaseAuth.instance.currentUser!.uid;

                  switch (item.type) {
                    case "image":
                      return ImageMessage(
                        key: UniqueKey(),
                        ownMessage: isOwnMessage,
                        message: item,
                        doc: controller.collection.doc(item.msgId),
                      );

                    case "file":
                      return FileMessage(
                        key: UniqueKey(),
                        message: item,
                        ownMessage: isOwnMessage,
                        doc: controller.collection.doc(item.msgId),
                      );

                    default:
                      return ChatMessage(
                        key: UniqueKey(),
                        ownMessage: isOwnMessage,
                        message: item,
                        doc: controller.collection.doc(item.msgId),
                        initials: controller.initials,
                        photoUrl: controller.reporter.photoUrl,
                      );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                .add(const EdgeInsets.symmetric(vertical: 30)),
            child: ChatBottomBar(controller: controller),
          ),
        ],
      ),
    );
  }
}


// var item = controller.messages.reversed.elementAt(i);
//                     bool isOwnMessage = item.sender == FirebaseAuth.instance.currentUser!.uid;

//                     switch (item.type) {
//                       case "image":
//                         return ImageMessage(
//                           key: UniqueKey(),
//                           ownMessage: isOwnMessage,
//                           message: item,
//                           doc: controller.collection.doc(item.msgId),
//                         );

//                       case "file":
//                         return FileMessage(
//                           key: UniqueKey(),
//                           message: item,
//                           ownMessage: isOwnMessage,
//                           doc: controller.collection.doc(item.msgId),
//                         );

//                       default:
//                         return ChatMessage(
//                           key: UniqueKey(),
//                           ownMessage: isOwnMessage,
//                           message: item,
//                           doc: controller.collection.doc(item.msgId),
//                         );
//                     }
