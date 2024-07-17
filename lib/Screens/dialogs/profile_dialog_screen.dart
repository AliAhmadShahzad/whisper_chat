import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';

class ProfileDialogScreen extends StatefulWidget {
  const ProfileDialogScreen({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<ProfileDialogScreen> createState() => _ProfileDialogScreenState();
}

class _ProfileDialogScreenState extends State<ProfileDialogScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors.textColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: widget.user.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.message_outlined,size: 27,color: colors.textColor2,),
              Icon(Icons.call,size: 27,color: colors.textColor2,),
              Icon(Icons.video_call_outlined,size: 27,color: colors.textColor2,),
              Icon(Icons.info_outline,size: 27,color: colors.textColor2,),

            ],
          )
        ],
      ),
    );
  }
}
