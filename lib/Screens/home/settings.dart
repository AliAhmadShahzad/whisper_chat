import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/All_settings_for_user/privacy_screen/privacy_screen.dart';
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
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await APIs.getselfInfo();
    setState(() {
      list = [APIs.userData]; // Initialize list with userData
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.sizeOf(context).height,
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

  // Build the header with back button and title
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
          "SETTINGS",
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
        // height: MediaQuery.sizeOf(context).height - 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: colors.textColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUserTile(),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Account',
              subtitle: 'Privacy, security, details...',
              icon: Icons.account_circle_outlined,
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Chats',
              subtitle: 'History, wallpaper...',
              icon: Icons.message_outlined,
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Notifications',
              subtitle: 'Message, group and other',
              icon: Icons.notifications_none_outlined,
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Privacy',
              subtitle: 'Block contact, disappearing messages...',
              icon: Icons.lock_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));
              },
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Storage and data',
              subtitle: 'Network usage, auto download...',
              icon: Icons.memory_outlined,
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Help',
              subtitle: 'Help center, contact us...',
              icon: Icons.help_outline,
            ),
            SizedBox(height: 10.h),
            _buildSettingOption(
              title: 'Invite friend',
              icon: Icons.people_outline,
            ),
          ],
        ),
      ),
    );
  }

  // Build user tile at the top of settings list
  Widget _buildUserTile() {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20.h),
      leading: list.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: CachedNetworkImage(
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
          imageUrl: APIs.userData.image,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
      )
          : CircleAvatar(
        child: Icon(
          Icons.person,
          size: 90,
        ),
      ),
      title: Text(
        APIs.userData.name,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colors.textColor2,
          ),
        ),
      ),
      trailing: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: colors.containerColor4.withOpacity(0.3),
        ),
        child: Center(
          child: Icon(
            Icons.qr_code,
            size: 25,
            color: colors.containerColor2,
          ),
        ),
      ),
    );
  }

  // Build each setting option tile
  Widget _buildSettingOption({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
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
            color: colors.textColor2.withOpacity(0.6),
          ),
        ),
      )
          : null,
      leading: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: colors.containerColor4.withOpacity(0.3),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 25,
            color: colors.containerColor2,
          ),
        ),
      ),
    );
  }
}
