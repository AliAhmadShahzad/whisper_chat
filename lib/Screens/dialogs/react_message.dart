import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Colors/colors.dart';

class ReactMessage extends StatefulWidget {
  const ReactMessage({super.key});

  @override
  State<ReactMessage> createState() => _ReactMessageState();
}

class _ReactMessageState extends State<ReactMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        AlertDialog(
          backgroundColor: colors.textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.message_outlined,size: 27,color: colors.textColor2,),
                  Icon(Icons.call,size: 27,color: colors.textColor2,),
                  Icon(Icons.video_call_outlined,size: 27,color: colors.textColor2,),
                  Icon(Icons.info_outline,size: 27,color: colors.textColor2,),
                ],
              )
        ),
        Positioned(
          bottom: 0.h,
          height: 100.h,
          child: AlertDialog(
              backgroundColor: colors.textColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.reply,size: 30,color: colors.textColor2,),
                      Text('Reply')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.save_alt,size: 30,color: colors.textColor2,),
                      Text('Save')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.emoji_emotions_outlined,size: 30,color: colors.textColor2,),
                      Text('React')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.copy,size: 30,color: colors.textColor2,),
                      Text('Copy')
                    ],
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }
}
