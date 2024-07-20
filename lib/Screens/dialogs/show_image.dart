import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/models/chat_messages.dart';

import '../../Colors/colors.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({super.key, required this.user});
  final MessagesModel user;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {

    return
          CachedNetworkImage(
            imageUrl: widget.user.msg,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(
              child: Icon(Icons.person),
            ),
          );


  }
}
