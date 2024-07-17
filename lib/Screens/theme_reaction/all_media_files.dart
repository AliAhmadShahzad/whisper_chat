import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/api/apis.dart';
import 'package:whisper/models/chat_user_model.dart';

import '../../Colors/colors.dart';
import '../../models/chat_messages.dart';

class GetMediaImages extends StatefulWidget {
  final ChatUserModel chatUser;

  GetMediaImages({required this.chatUser});

  @override
  State<GetMediaImages> createState() => _GetMediaImagesState();
}

class _GetMediaImagesState extends State<GetMediaImages> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: APIs.getMediaImages(widget.chatUser), // Fetch images
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No images found.')); // No images
        }
        final imageUrls = snapshot.data!;
        return SafeArea(
          top: true,
          minimum: EdgeInsets.only(top: 34.h),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'View Media & Files',
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
              body: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Adjust for your layout
                    childAspectRatio: 0.7, // Adjusted aspect ratio
                    crossAxisSpacing: 4.0, // Add spacing if desired
                    mainAxisSpacing: 4.0, // Square images
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      height: 150.h,
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
