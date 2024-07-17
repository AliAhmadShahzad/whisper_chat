import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/All_settings_for_user/privacy_screen/blocked_contact.dart';

import '../../../Colors/colors.dart';
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
          "PRIVACY",
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
            Text('Who can see my personal Info',style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colors.containerColor4.withOpacity(0.6),
              ),
            ),),
            
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Last seen and Online',
              subtitle: 'Everyone',
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Profile Photo',
              subtitle: 'Everyone',
              
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'About',
              subtitle: 'Everyone',
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Groups',
              subtitle: 'Everyone',
              onTap: () {
                // Handle tap
              },
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Live Location',
              subtitle: 'None',
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Blocked Contacts',
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BlockedContact()));
              }
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'App lock',
              subtitle: 'Disabled',
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Chat lock',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 20.sp,
            // fontWeight: FontWeight.bold,
            color: colors.textColor2,
          ),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 16.sp,
            color: colors.textColor3.withOpacity(0.6)
          ),
        ),
      )
          : null,
    );
  }
}
