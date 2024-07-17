import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/messenger/messages.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../api/apis.dart';
import '../home/chat_Screen.dart';
class EmojisScreen extends StatefulWidget {
  const EmojisScreen({super.key, required this.users});
  final ChatUserModel users;

  @override
  State<EmojisScreen> createState() => _EmojisScreenState();
}

class _EmojisScreenState extends State<EmojisScreen> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: EmojiPicker(
        textEditingController: _textController,
        onEmojiSelected: (category, emoji) async {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          String theme = await APIs.getTheme(widget.users);
          APIs.updateEmoji(widget.users, _textController.text).then((value)=> Messages.showSnackbar(context,'Emoji Updated Successfully'));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatScreen(user: widget.users, theme: theme, emoji: _textController.text,key: UniqueKey(),)));
        },
        config: Config(
            height: 400,

            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax:
              28 * (Platform.isIOS ? 1.20 : 1.0),
              columns: 5,
              backgroundColor: Colors.white
            ),
          bottomActionBarConfig: BottomActionBarConfig(buttonColor: Colors.white,backgroundColor: Colors.white,buttonIconColor: Colors.deepOrangeAccent)
            ),
      ),
    );
  }
}
