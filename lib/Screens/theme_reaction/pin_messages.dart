import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/api/apis.dart';
import 'package:whisper/messenger/messages.dart';
import 'package:whisper/models/chat_messages.dart';
import 'package:whisper/models/chat_user_model.dart';
import 'package:whisper/models/pin_messages.dart';

import '../../Colors/colors.dart';
import '../../helper/time_Formater.dart';


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
              ),):
              Column(
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: pinmessages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onLongPress: (){

                             showModalBottomSheet(
                                 context: context,
                                 shape: const RoundedRectangleBorder(
                                     borderRadius: BorderRadius.only(
                                         topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                 builder: (_){
                               return ListView(
                                 shrinkWrap: true,
                                 children: [
                                   Container(
                                     height: 4,
                                     margin: EdgeInsets.symmetric(
                                         vertical: 20.h, horizontal:30.w),
                                     decoration: const BoxDecoration(
                                         color: Colors.grey,
                                         borderRadius: BorderRadius.all(Radius.circular(8))),
                                   ),

                                   _OptionItem(
                                       icon: const Icon(Icons.copy_all_rounded,
                                           color: Colors.blue, size: 26),
                                       name: 'Copy',
                                       onTap: () async {
                                         await Clipboard.setData(
                                             ClipboardData(text: pinmessages[index].message))
                                             .then((value) {
                                           //for hiding bottom sheet
                                           Navigator.pop(context);

                                           Messages.showSnackbar(context, 'Text Copied!');
                                         });
                                       }),
                                   _OptionItem(
                                       icon: const Icon(Icons.remove,
                                           color: Colors.red, size: 26),
                                       name: 'Remove',
                                       onTap: () async {

                                         await APIs.deletePinMessages(widget.chatUser.id,pinmessages[index].message).then((onValue)=> Messages.showSnackbar(context,'Deleted Successfully'));
                                       }),

                                   //separator or divider
                                   Divider(
                                     color: Colors.black54,
                                     endIndent: 10,
                                     indent: 10,
                                   ),

                                   //sent time

                                 ],
                               );
                             });
                      },
                              child: ListTile(
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
                            ),
                          ],
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: 20.w,
              top: 10.h,
              bottom: 10.w),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
