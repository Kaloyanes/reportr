import 'dart:ui';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:reportr/app/modules/chats/controllers/chat_controller.dart';

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 2:
                  controller.takePicture();
                  break;

                case 4:
                  controller.pickFile();
                  break;
              }
            },
            clipBehavior: Clip.hardEdge,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text("Снимка"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.file_upload),
                    SizedBox(width: 10),
                    Text("Файл"),
                  ],
                ),
              ),
            ],
            enableFeedback: true,
            icon: const Icon(
              Icons.add,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: AutoSizeTextField(
              keyboardType: TextInputType.multiline,
              controller: controller.messageController,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              // minFontSize: 20,
              presetFontSizes: const [
                18,
                16,
                14,
                12,
                10,
                8,
              ],
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                hintText: "Напиши съобщение...",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: IconButton(
              onPressed: controller.sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PopupMenuButton(
//             onSelected: (value) {
//               switch (value) {
//                 case 2:
//                   controller.takePicture();
//                   break;

//                 case 4:
//                   controller.pickFile();
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 2,
//                 child: Row(
//                   children: [
//                     Icon(Icons.image),
//                     SizedBox(width: 10),
//                     Text("Снимка"),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 4,
//                 child: Row(
//                   children: [
//                     Icon(Icons.file_upload),
//                     SizedBox(width: 10),
//                     Text("Файл"),
//                   ],
//                 ),
//               ),
//             ],
//             enableFeedback: true,
//             icon: const Icon(
//               Icons.add,
//             ),
//             iconSize: 30,
//           ),
