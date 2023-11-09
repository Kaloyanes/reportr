import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/chats/controllers/chat_controller.dart';

class MessageSettings extends StatelessWidget {
  MessageSettings({super.key, required this.doc, this.ref});

  final DocumentReference doc;

  Reference? ref;

  @override
  Widget build(BuildContext context) {
    HapticFeedback.lightImpact();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 5,
          width: Get.size.width / 3,
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).dividerColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text("delete_message".tr),
          onTap: () async {
            Get.back();
            Get.find<ChatController>().messages.removeWhere((element) => element.msgId == doc.id);
            doc.delete();

            inspect(ref);

            if (ref != null) {
              await ref!.delete();
            }
          },
          tileColor: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
        SizedBox(
          height: Get.mediaQuery.padding.bottom,
        )
      ],
    );
  }
}
