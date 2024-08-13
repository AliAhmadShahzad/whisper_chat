import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../../Colors/colors.dart';
import '../../../api/apis.dart';
class BlockedContact extends StatefulWidget {
  const BlockedContact({super.key});

  @override
  State<BlockedContact> createState() => _BlockedContactState();
}

class _BlockedContactState extends State<BlockedContact> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 60.h),
          height: MediaQuery.of(context).size.height,
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
              _buildHeader(context),
              _buildSettingsList(),


            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: colors.containerColor4,
          ),
        ),
        SizedBox(width: 50.w),
        Text(
          "BLOCKED CONTACTS",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 20,
              color: colors.textColor,
            ),
          ),
        ),
      ],
    );
  }

  // Build the settings list
  Widget _buildSettingsList() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 30.h),
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.h),
        height: MediaQuery.sizeOf(context).height -130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: colors.textColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contacts",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 20.sp,
                  color: colors.containerColor4.withOpacity(0.7),
                ),
              ),
            ),
            StreamBuilder(
                stream: APIs.getAllBlockUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var list = snapshot.data!.docs.map((doc) => ChatUserModel.fromJson(doc.data())).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20.h),
                    itemCount: list.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                          title: MaterialButton(
                            onPressed: (){
                              Navigator.pop(context);
                              APIs.unblockUser(list[index].id);
                            },
                            // padding: EdgeInsets.only(top: 24.h),
                            child: Text('Unblock ${list[index].name}',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textColor2,
                              ),
                            ),),
                          ),
                          ));
                        },
                        child: ListTile(
                          title: list[index].name!=null ?Text(list[index].name,style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),):
                              Text('getting some error list is null'),
                          subtitle: Text(list[index].email,style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              color: colors.textColor2,
                            ),
                          ),),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: list[index].image,
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Blocked User",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          color: colors.textColor2,
                        ),
                      ),
                    ),
                  );
                }
              },
                ),
            SizedBox(height: 40.h,),
            Text('Blocked contacts will no longer be able to call or send you a messages',style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16.sp,
                color: colors.textColor3.withOpacity(0.6),
              ),
            ),),
          ],
        ),
      ),
    );
  }

}
