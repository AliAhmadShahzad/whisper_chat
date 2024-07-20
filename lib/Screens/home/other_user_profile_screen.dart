import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/home/home_Screen.dart';
import 'package:whisper/Screens/theme_reaction/themes_screen.dart';
import 'package:whisper/Screens/theme_reaction/word_effect.dart';
import 'package:whisper/helper/time_Formater.dart';
import 'package:whisper/messenger/messages.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../theme_reaction/all_media_files.dart';
import '../theme_reaction/emojis.dart';
import '../theme_reaction/pin_messages.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  bool _checkBlockbox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 70.h,bottom: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.textColor,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: CachedNetworkImage(
                      height: 170.h,
                      width: 170.w,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  SizedBox(height:10.h,),
                  Text(widget.user.name,textAlign: TextAlign.center,style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor2,
                    ),
                  ),),
                  // SizedBox(height:10.h,),
                  Text(widget.user.email,textAlign: TextAlign.center,style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      color: colors.textColor2,
                    ),
                  ),),
                  SizedBox(height:10.h,),
                  Text(FormatTime.getLastActiveTime(context: context, lastActive: widget.user.lastActive),textAlign: TextAlign.center,style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      color: colors.textColor2,
                    ),
                  ),),
                  Row(
                    children: [
                      Container(
                        width: 120.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 15.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call,size: 30,color: colors.containerColor2,),
                            Text('Audio',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 18.sp,
                                color: colors.containerColor2,
                              ),
                            ),),
                          ],
                        ),
                      ),
                      Container(
                        width: 120.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 15.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_call_outlined,size: 30,color: colors.containerColor2,),
                            Text('Video',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 18.sp,
                                color: colors.containerColor2,
                              ),
                            ),),
                          ],
                        ),
                      ),
                      Container(
                        width: 120.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 15.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search,size: 30,color: colors.containerColor2,),
                            Text('Search',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 18.sp,
                                color: colors.containerColor2,
                              ),
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Customization',style: GoogleFonts.roboto(
            textStyle: TextStyle(
            fontSize: 18.sp,
            color: colors.textColor2,
            ),
            ),),
            ),
            SizedBox(height: 5.h,),
            Container(
              padding: EdgeInsets.only(top: 10.h,bottom: 15.h,left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.textColor,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      showDialog(context: context, builder: (context)=> ThemesScreen(user: widget.user));
                    },
                    child: Row(
                      children: [
                        Text('✨',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Theme',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder: (context)=> EmojisScreen(users: widget.user,));
                    },
                    child: Row(
                      children: [
                        Text('😊',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Quick Reaction',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      Text('Aa',style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),),
                      SizedBox(width: 15.w),
                      Text('Nicknames',style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: colors.containerColor2,
                        ),
                      ),),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WordEffect(user: widget.user,key: UniqueKey(),)));
                    },
                    child: Row(
                      children: [
                        Text('🖌️',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Word effects',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('More Actions',style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  color: colors.textColor2,
                ),
              ),),
            ),
            SizedBox(height: 5.h,),
            Container(
              padding: EdgeInsets.only(top: 10.h,bottom: 15.h,left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.textColor,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      showDialog(context: context, builder: (context)=> GetMediaImages(chatUser: widget.user));
                    },
                    child: Row(
                      children: [
                        Text('🌌',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('View media & files',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Row(
                      children: [
                        Text('⬇️',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Save photos & videos',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>GetPinMessages(chatUser: widget.user)));
                    },
                    child: Row(
                      children: [
                        Text('📌',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('View pinned Messages',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){
                    },
                    child: Row(
                      children: [
                        Text('🔍',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Search in conversation',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Privacy & support',style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  color: colors.textColor2,
                ),
              ),),
            ),
            SizedBox(height: 5.h,),
            Container(
              padding: EdgeInsets.only(top: 10.h,bottom: 15.h,left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.textColor,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){

                    },
                    child: Row(
                      children: [
                        Text('📂',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Move to achieved',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){
                      // Navigator.pop(context);
                      _showBlockDialog();
                    },
                    child: Row(
                      children: [
                        Text('⛔️',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                        SizedBox(width: 15.w),
                        Text('Block ',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  GestureDetector(
                    onTap: (){},
                    child: Row(
                      children: [
                        Icon(Icons.report,size: 30,color: Color.fromARGB(
                            255, 225, 22, 7),),
                        SizedBox(width: 10.w),
                        Text('Report',style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: colors.containerColor2,
                          ),
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Block',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: colors.containerColor1,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Blocking a contact will permanently remove them from your list. Once blocked, they will no longer be able to call or send you messages',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 17.sp,
                  color: colors.containerColor2,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent, // Ensure GestureDetector doesn't block checkbox
                  onTap: () {
                    setState(() {
                      _checkBlockbox = !_checkBlockbox;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: colors.textColor,
                        checkColor: colors.containerColor2,
                        value: _checkBlockbox,
                        onChanged: (value) {
                          setState(() {
                            _checkBlockbox = value ?? false; // Ensure value is not null
                          });
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report Contact',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.containerColor3,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '''The last 5 messages will'
be forwarded to Whisper.''',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                color: colors.containerColor2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.containerColor1,
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              APIs.blockUser(widget.user.id,widget.user.name,widget.user.image,widget.user.email).then((onValue){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Messages.showSnackbar(context, 'Blocked Successfully');
              });
            },
            child: Text(
              'Block',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.containerColor1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
