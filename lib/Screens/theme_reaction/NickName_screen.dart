
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/chat_messages.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../../messenger/messages.dart';
import '../../models/chat_user_model.dart';


class NicknameScreen extends StatefulWidget {
  const NicknameScreen({Key? key, required this.user}) : super(key: key);
  final ChatUserModel user;

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
TextEditingController _nickNameController = TextEditingController();
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
              'Nicknames',
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
                    'Your Nicknames',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  FutureBuilder<List<Map<String, String>>>(
                    future: APIs.getChattingUsers(widget.user.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator()); // Loading
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}')); // Error
                      }

                      List<Map<String, String>> nicknames = snapshot.data ?? [];

                      return ListView.builder(
                        shrinkWrap: true, // Add this line to avoid overflow
                        physics: NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: nicknames.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap:(){
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content:  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Edit Nickname',style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colors.containerColor2,
                                          ),
                                        ),),
                                        SizedBox(height: 10.h,),
                                        Text('Only you can able to see this nickname  in this conversation',style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 15.sp,
                                            color: colors.containerColor2,
                                          ),
                                        ),),
                                        SizedBox(height: 10.h,),
                                        TextField(
                                          controller: _nickNameController,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            hintText: 'Enter nickname',
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            )
                                          ),
                                        ),
                                        SizedBox(height: 10.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: WidgetStateProperty.all(Colors.transparent)
                                                ),
                                                child: Text('Cancel',style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.containerColor4,
                                                ),
                                  ),)),
                                            SizedBox(width: 40.w,),
                                            TextButton(
                                                onPressed: (){
                                                  APIs.setNickName(widget.user.id,_nickNameController.text.toString()).then((onValue){
                                                    Navigator.pop(context);
                                                    Messages.showSnackbar(context,'Nickname added successfully');
                                                  }

                                                  );
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStateProperty.all(Colors.transparent)
                                                ),
                                                child: Text('Set',style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: colors.containerColor4,
                                                  ),
                                                ),)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },

                            child: ListTile(
                              title: Text(widget.user.name,style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.containerColor2,
                                ),
                              ),),
                              subtitle: Text('Yoo',style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.containerColor4,
                                ),
                              ),),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: CachedNetworkImage(
                                  height: 60.h,
                                  width: 60.w,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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

