import 'dart:ui';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:reportr/app/modules/chats/controllers/chat_controller.dart';

class ChatBottomBar extends StatefulWidget {
  const ChatBottomBar({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  bool hasText = false;

  @override
  void initState() {
    widget.controller.messageController.addListener(() {
      setState(() {
        hasText = widget.controller.messageController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 2:
                    widget.controller.takePicture();
                    break;

                  case 4:
                    widget.controller.pickFile();
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
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
            alignment: hasText ? const Alignment(-0.1, 0) : Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutExpo,
              width: hasText ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.85,
              child: AutoSizeTextField(
                keyboardType: TextInputType.multiline,
                controller: widget.controller.messageController,
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
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
            alignment: hasText ? Alignment.centerRight : const Alignment(1.5, 0.5),
            child: Container(
              width: 50,
              height: 50,
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
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.controller.sendMessage,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
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
