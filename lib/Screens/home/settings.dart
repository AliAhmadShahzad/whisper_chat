import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';

class SettingScreenUser extends StatefulWidget {
  const SettingScreenUser({super.key});

  @override
  State<SettingScreenUser> createState() => _SettingScreenUserState();
}

class _SettingScreenUserState extends State<SettingScreenUser> {
  List<ChatUserModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await APIs.getselfInfo();
    setState(() {
      list = [APIs.userData]; // Assuming userData should be part of the list initially
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.only(top: 60.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.containerColor1,
                  colors.containerColor2,
                  colors.containerColor3,
                  colors.containerColor4,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: colors.containerColor4,
                        )),
                         SizedBox(width: 100.w,),

                         Text(
                      "SETTINGS",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: colors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  padding: EdgeInsets.only(top: 35.h, left: 20.h, right: 20.h),
                  height: MediaQuery.sizeOf(context).height - 150.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: colors.textColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h,),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 20.h),
                        leading: list.isNotEmpty? ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: CachedNetworkImage(
                            height: 60.h,
                            width: 60.w,
                            fit: BoxFit.cover,
                            imageUrl: APIs.userData.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          ),
                        ):
                        Container(
                          height: 60.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: CircleAvatar(
                            child: Icon(Icons.person,size: 90,),
                          ),
                        ),

                        title: Text(APIs.userData.name, style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.textColor2,
                          ),
                        ),),
                        trailing: Container(
                          height: 50.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: colors.containerColor4.withOpacity(0.3)
                          ),
                          child: Center(child: Icon(Icons.qr_code,size: 25,color: colors.containerColor2,)),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      ListTile(
                        title: Text('Account', style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.textColor2,
                          ),
                        ),),

                        subtitle: Text('Privacy,security,details...', style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: colors.textColor2.withOpacity(0.6),
                          ),
                        ),),
                        leading: Container(
                          height: 50.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: colors.containerColor4.withOpacity(0.3)
                          ),
                          child: Center(child: Icon(Icons.account_circle_outlined,size: 25,color: colors.containerColor2,)),
                        )
                      ),
                      SizedBox(height: 10.h,),
                      ListTile(
                          title: Text('Chats', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),),

                          subtitle: Text('History,wallpaper...', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textColor2.withOpacity(0.6),
                            ),
                          ),),
                          leading: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors.containerColor4.withOpacity(0.3)
                            ),
                            child: Center(child: Icon(Icons.message_outlined,size: 25,color: colors.containerColor2,)),
                          )
                      ),
                      SizedBox(height: 10.h,),
                      ListTile(
                          title: Text('Notifications', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),),

                          subtitle: Text('Message,group and other', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textColor2.withOpacity(0.6),
                            ),
                          ),),
                          leading: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors.containerColor4.withOpacity(0.3)
                            ),
                            child: Center(child: Icon(Icons.notifications_none_outlined,size: 25,color: colors.containerColor2,)),
                          )
                      ),SizedBox(height: 20.h,),
                      ListTile(
                          title: Text('Block users', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),),

                          subtitle: Text('Block contact,unblock,detail...', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textColor2.withOpacity(0.6),
                            ),
                          ),),
                          leading: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors.containerColor4.withOpacity(0.3)
                            ),
                            child: Center(child: Icon(Icons.block_flipped,size: 25,color: colors.containerColor2,)),
                          )
                      ),SizedBox(height: 20.h,),
                      ListTile(
                          title: Text('Help', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),),

                          subtitle: Text('Help center, contact us...', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textColor2.withOpacity(0.6),
                            ),
                          ),),
                          leading: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors.containerColor4.withOpacity(0.3)
                            ),
                            child: Center(child: Icon(Icons.help_outline,size: 25,color: colors.containerColor2,)),
                          )
                      ),SizedBox(height: 20.h,),
                      ListTile(
                          title: Text('Invite friend', style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),),

                          leading: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors.containerColor4.withOpacity(0.3)
                            ),
                            child: Center(child: Icon(Icons.people_outline,size: 25,color: colors.containerColor2,)),
                          )
                      ),SizedBox(height: 20.h,),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
