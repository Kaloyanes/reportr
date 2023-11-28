import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportr/app/modules/chats/components/message_settings.dart';
import 'package:reportr/app/modules/chats/models/message_model.dart';

class FileMessage extends StatelessWidget {
  const FileMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc,
      required this.photoUrl,
      required this.initials});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;
  final String photoUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseStorage.instance.refFromURL(message.value);

    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          if (!ownMessage) return;

          await showDialog<String>(
            context: context,
            builder: (context) => Material(
              child: MessageSettings(
                doc: doc,
              ),
            ),
          );
        },
        onTap: () async {
          Dio dio = Dio();
          Directory dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
          String path = dir.path;

          if (File("$path/${ref.name}").existsSync()) {
            OpenFile.open('$path/${ref.name}');
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("start_download".trParams({"file": ref.name})),
              behavior: SnackBarBehavior.floating,
              // elevation: 20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
          );

          await dio.download(message.value, '$path/${ref.name}');
          ScaffoldMessenger.of(Get.context!).clearSnackBars();
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text("finished_download".trParams({"file": ref.name})),
              behavior: SnackBarBehavior.floating,
              elevation: 20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
          );

          // Open File
          OpenFile.open('$path/${ref.name}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!ownMessage)
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    radius: 17,
                    foregroundImage: CachedNetworkImageProvider(photoUrl),
                    child: Text(initials),
                  ),
                ),
              Container(
                alignment: Alignment.centerRight,
                constraints: BoxConstraints(maxWidth: Get.width / 2),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: ownMessage ? const Radius.circular(40) : const Radius.circular(10),
                    bottomRight: const Radius.circular(40),
                    bottomLeft: const Radius.circular(40),
                    topRight: ownMessage ? const Radius.circular(10) : const Radius.circular(40),
                  ),
                  color: ownMessage
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: ownMessage
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      blurRadius: 15,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.file_download,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ref.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
