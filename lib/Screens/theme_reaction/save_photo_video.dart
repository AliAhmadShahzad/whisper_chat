import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../../models/chat_user_model.dart';
class savePhotoVideo extends StatefulWidget {
   savePhotoVideo({super.key, required this.chatUser});
   final ChatUserModel chatUser;

  @override
  State<savePhotoVideo> createState() => _savePhotoVideoState();
}

class _savePhotoVideoState extends State<savePhotoVideo> {

  bool isOn = false;

  void toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 34.h),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Save Photos & videos',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.containerColor1,
                ),
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camera roll',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Save photos & videos you receive',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.containerColor2,
                          ),
                        ),
                      ),
                      Switch(
                          value: isOn,
                          onChanged: toggleSwitch,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.black54,
                        inactiveTrackColor:Colors.grey.shade300,
                      )
                    ],
                  ),
                  SizedBox(height: 30.h,),
                  Text(
                    'Automatically save photos and videos that you receive in this chat to your camera roll.Photos and Videos saved to your device will not be encrypted'
                        ,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: colors.textColor3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
