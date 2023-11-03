import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reportr/app/modules/chats/components/message_settings.dart';
import 'package:reportr/app/modules/chats/models/message_model.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc,
      required this.initials,
      required this.photoUrl});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;
  final String initials;
  final String photoUrl;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  DateFormat formatter = DateFormat("H:mm | d/MM/yyyy");

  bool showInfo = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          if (!widget.ownMessage) return;

          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => MessageSettings(
              doc: widget.doc,
            ),
          );
        },
        onTap: () {
          setState(() {
            showInfo = !showInfo;
          });
          HapticFeedback.selectionClick();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: widget.ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.ownMessage)
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    radius: 17,
                    foregroundImage: CachedNetworkImageProvider(widget.photoUrl),
                    child: Text(widget.initials),
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: Get.width / 2),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: widget.ownMessage ? const Radius.circular(40) : const Radius.circular(10),
                          bottomRight: const Radius.circular(40),
                          bottomLeft: const Radius.circular(40),
                          topRight: widget.ownMessage ? const Radius.circular(10) : const Radius.circular(40),
                        ),
                        color: widget.ownMessage
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: widget.ownMessage
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.secondaryContainer,
                            blurRadius: 15,
                            offset: const Offset(0, 0),
                          ),
                        ]),
                    child: Text(
                      widget.message.value,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  AnimatedContainer(
                    margin: EdgeInsets.only(top: showInfo ? 10 : 0),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: showInfo ? 20 : 0,
                    duration: 600.ms,
                    alignment: widget.ownMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      formatter.format(widget.message.time),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
