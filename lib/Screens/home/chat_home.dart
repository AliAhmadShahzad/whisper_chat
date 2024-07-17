import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/home/chat_Screen.dart';
import 'package:whisper/helper/time_Formater.dart';
import 'package:whisper/models/chat_messages.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../dialogs/profile_dialog_screen.dart';

class ChatHome extends StatefulWidget {
  final ChatUserModel user;

  ChatHome({Key? key, required this.user});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  MessagesModel? _messages;
  bool _initializer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return true; // Return true to dismiss
      },
      onDismissed: (direction) async {
        await APIs.deleteChat(widget.user);
        setState(() {
          _messages = null; // Clear any remaining message
        });
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 20.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: InkWell(
          onTap: () async {
            String emoji = await APIs.getEmoji(widget.user) ?? '👍';
            String theme = await APIs.getTheme(widget.user) ?? 'assets/defaultTheme.png';
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(user: widget.user, theme: theme, emoji: emoji)),
            );
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final list = snapshot.data?.docs
                  .map((doc) => MessagesModel.fromJson(doc.data() as Map<String, dynamic>))
                  .toList();
              if (list!.isNotEmpty) {
                _messages = list[0] as MessagesModel?;
              }

              return ListTile(
                title: Text(
                  widget.user.name,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor2,
                    ),
                  ),
                ),
                subtitle: Text(
                  _messages != null ? (_messages!.type == Type.image ? "image" : _messages!.msg) : widget.user.lastMessage,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: colors.textColor2,
                    ),
                  ),
                ),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ProfileDialogScreen(user: widget.user),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      height: 40.h,
                      width: 40.w,
                      imageUrl: widget.user.image,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                trailing: _messages == null
                    ? null
                    : _messages!.read.isEmpty && _messages?.fromid != APIs.users.uid
                    ? Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                )
                    : Text(
                  FormatTime.getLastMessageTime(context: context, time: _messages!.sent),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


}

