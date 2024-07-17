import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../../messenger/messages.dart';
import '../home/chat_Screen.dart';

class ThemesScreen extends StatefulWidget {
  ThemesScreen({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  List images = [
    'assets/defaultTheme.png',
    'assets/theme1.png',
    'assets/theme2.png',
    'assets/theme3.png',
    'assets/theme4.png',
    'assets/theme5.png',
    'assets/theme6.png',
  ];
  List imageTitle = [
    'Default Theme',
    'Theme 1',
    'Theme 2',
    'Theme 3',
    'Theme 4',
    'Theme 5',
    'Theme 6',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ListView.builder(
          itemCount: images.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                // Retrieve emoji and update theme
                String emoji = await APIs.getEmoji(widget.user);
                APIs.updateTheme(widget.user, images[index]).then((onValue)=> Messages.showSnackbar(context,'Theme updated Successfully'));

                // Close the dialog
                Navigator.pop(context);

                // Navigate to ChatScreen with pushReplacement
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      user: widget.user,
                      theme: images[index],
                      emoji: emoji,
                      key: UniqueKey(), // Ensure a unique key to force rebuild
                    ),
                  ),
                );
              },

              child: ListTile(
                title: Text(imageTitle[index],style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.containerColor1,
                  ),
                ),),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(images[index]),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
