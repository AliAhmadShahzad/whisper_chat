import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../../Colors/colors.dart';
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
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: colors.containerColor4,
          ),
        ),
        SizedBox(width: 100.w),
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
        // height: MediaQuery.sizeOf(context).height -130,
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
                  fontSize: 20,
                  color: colors.containerColor4.withOpacity(0.7),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}
