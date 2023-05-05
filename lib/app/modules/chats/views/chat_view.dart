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
        key: controller.appBarKey,
        leadingWidth: 40,
        elevation: 1,
        title: GestureDetector(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Hero(
                      transitionOnUserGestures: true,
                      tag: controller.reporter,
                      child: CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(controller.reporter.photoUrl),
                        child: Text(controller.initials),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Hero(
                      transitionOnUserGestures: true,
                      flightShuttleBuilder:
                          (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) =>
                              AnimatedBuilder(
                        animation: animation,
                        child: toHeroContext.widget,
                        builder: (_, child) {
                          return DefaultTextStyle.merge(
                            child: child ?? const Text("maika ti"),
                            style: TextStyle.lerp(
                              DefaultTextStyle.of(toHeroContext).style,
                              DefaultTextStyle.of(fromHeroContext).style,
                              flightDirection == HeroFlightDirection.pop ? 1 - animation.value : animation.value,
                            ),
                          );
                        },
                      ),
                      tag: controller.docId,
                      child: Text(
                        controller.reporter.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text(
                          "Изтрий чата",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onTap: () => controller.deleteChat(),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => CupertinoScrollbar(
                controller: controller.listController,
                child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  addAutomaticKeepAlives: true,
                  cacheExtent: 500,
                  semanticChildCount: controller.messages.length,
                  itemCount: controller.messages.length,
                  reverse: true,
                  controller: controller.listController,
                  itemBuilder: (context, i) {
                    var item = controller.messages.reversed.elementAt(i);
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
                        );
                    }
                  },
                ),
              ),
            ),
          ),
          AnimatedContainer(
            curve: Curves.easeOutCirc,
            duration: 300.milliseconds,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ChatBottomBar(controller: controller),
          ),
        ],
      ),
    );
  }
}
