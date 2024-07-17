import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/api/apis.dart';
import 'package:whisper/models/chat_user_model.dart';
import 'package:whisper/models/pin_messages.dart';

import '../../Colors/colors.dart';
import '../../helper/time_Formater.dart';
import '../../models/chat_messages.dart';

class GetPinMessages extends StatefulWidget {
  final ChatUserModel chatUser;

  GetPinMessages({required this.chatUser});

  @override
  State<GetPinMessages> createState() => _GetPinMessagesState();
}

class _GetPinMessagesState extends State<GetPinMessages> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PinMessagesModels>>(
      future: APIs.getPinMessages(widget.chatUser.id), // Fetch images
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error
        }
        List<PinMessagesModels> pinmessages = snapshot.data??[];
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
                  'Pin Messages',
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
              body: pinmessages.isEmpty? Text('No Pinned messages saved',style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 20.sp,

                  color: colors.containerColor1,
                ),
              ),): ListView.builder(
                shrinkWrap: true,
                itemCount: pinmessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Message',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.containerColor4,
                              ),
                            ),),
                            Text('Pinned date',style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.containerColor4,
                              ),
                            ),),
                          ],
                        ),
                        ListTile(
                          title: Text(pinmessages[index].message,style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 18.sp,

                              color: colors.containerColor1,
                            ),
                          ),),
                          trailing: Text(FormatTime.getLastMessageTime(context: context, time: pinmessages[index].time),style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: colors.textColor2,
                            ),
                          ),),
                        ),
                      ],
                    )
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
