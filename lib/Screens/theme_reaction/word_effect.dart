import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';
import '../../messenger/messages.dart';
import '../../models/chat_user_model.dart';
import '../../models/word_effect_models.dart';
import 'adding_effects.dart';

class WordEffect extends StatefulWidget {
  const WordEffect({Key? key, required this.user}) : super(key: key);
  final ChatUserModel user;

  @override
  State<WordEffect> createState() => _WordEffectState();
}

class _WordEffectState extends State<WordEffect> {
  TextEditingController _emojiController = TextEditingController();
  TextEditingController _wordController = TextEditingController();
  bool _showEmojiPicker = false;

  final list = [];

  @override
  Widget build(BuildContext context) {
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
              'Word Effects',
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
                    'Your Effects',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    // height: 300.h, // Adjust the height as needed
                    child: StreamBuilder(
                      stream: APIs.getWordEfect(widget.user),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              'No word effects found',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor2,
                                ),
                              ),
                            ),
                          );
                        }

                        final list = snapshot.data?.docs
                            .map((doc) => WordEffectModels.fromJson(doc.data()))
                            .toList();

                        return ListView.builder(
                          itemCount: list?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {

                            return AddingEffects(message: list![index]);
                          },
                        );
                      },
                    )

                  ),
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _showEmojiPicker = true;
                          });
                        },
                        child: Center(
                          child: Text(_emojiController.text.isNotEmpty? _emojiController.text: ' ➕',style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor2,
                            ),
                          ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _wordController,
                          decoration: InputDecoration(
                            hintText: 'Add a Word or Phrase',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showEmojiPicker)


                    EmojiPicker(
                        textEditingController: _emojiController,
                        onEmojiSelected: (category, emoji) {
                          setState(() {
                            _emojiController.text = emoji.emoji;
                            _showEmojiPicker = false;
                          });
                        },

                        config: Config(
                          height: 350,
                          emojiViewConfig: EmojiViewConfig(
                            emojiSizeMax:
                            28 * (Platform.isIOS ? 1.20 : 1.0),
                            columns: 6,
                            backgroundColor: Colors.white,
                          ),
                          bottomActionBarConfig: BottomActionBarConfig(
                            buttonColor: Colors.white,
                            backgroundColor: Colors.white,
                            buttonIconColor: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),

                  SizedBox(height: 20,),
                  Center(
                    child: MaterialButton(onPressed: (){
                      APIs.storeWordEffect(widget.user, _wordController.text, _emojiController.text).then((onValue)=>Messages.showSnackbar(context,'Word Effect added Successfully'));
                    },
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      color: colors.textColor2,
                      child: Text('Add',style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
