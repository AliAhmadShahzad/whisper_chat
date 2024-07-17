import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/dialogs/show_image.dart';
import 'package:whisper/api/apis.dart';
import 'package:whisper/helper/time_Formater.dart';
import 'package:whisper/messenger/messages.dart';

import '../../Colors/colors.dart';
import '../../models/chat_messages.dart';
import '../../models/word_effect_models.dart';
import '../dialogs/bottom_dialog.dart';

class MessagesDisplayScreen extends StatefulWidget {
  MessagesDisplayScreen({
    super.key,
    required this.messages,
    required this.wordEffects,
  });
  final MessagesModel messages;
  final List<WordEffectModels> wordEffects;

  @override
  State<MessagesDisplayScreen> createState() => _MessagesDisplayScreenState();
}

class _MessagesDisplayScreenState extends State<MessagesDisplayScreen>
    with TickerProviderStateMixin {
  RegExp emojiRegExp = RegExp(
    r'^[\u{1F300}-\u{1FAD6}\u{1F90D}-\u{1F9CF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}'
    r'\u{1F170}-\u{1F251}\u{1F004}-\u{1F0CF}\u{1F30D}-\u{1F567}\u{1F191}-\u{1F251}'
    r'\u{1F1E6}-\u{1F1FF}\u{1F300}-\u{1F5FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}'
    r'\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}'
    r'\u{2700}-\u{27BF}]+$',
    unicode: true,
  );

  late AnimationController _animationController;
  late AnimationController _effectAnimationController;
  late List<_AnimatedEmoji> _emojis = [];
  late List<_AnimatedEffect> _effects = [];
  late Map<String, WordEffectModels> wordEffectMap = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _effectAnimationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Initialize the word effect map
    for (var wordEffect in widget.wordEffects) {
      wordEffectMap[wordEffect.word.toLowerCase()] = wordEffect;
    }

    _checkAndAnimateEffects(widget.messages.msg);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _effectAnimationController.dispose();
    super.dispose();
  }

  void _startEmojiAnimation(String emoji) {
    _emojis = List.generate(40, (index) => _AnimatedEmoji(
      emoji: emoji,
      key: UniqueKey(), // UniqueKey for each instance
      context: context,
    ));
    _animationController.reset();
    _animationController.forward();
  }

  void _startEffectAnimation(String effect) {
    _effects = List.generate(50, (index) => _AnimatedEffect(
      effect: effect,
      key: UniqueKey(), // UniqueKey for each instance
      context: context,
    ));
    _effectAnimationController.reset();
    _effectAnimationController.forward();
  }

  void _checkAndAnimateEffects(String text) {
    for (var wordEffect in wordEffectMap.entries) {
      if (text.toLowerCase().contains(wordEffect.key)) {
        _startEffectAnimation(wordEffect.value.effect);
        return; // Exit loop after finding the first match
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return APIs.users.uid == widget.messages.fromid
        ? _myMessage()
        : _otherMessages();
  }

  _myMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 10.h),
        emojiRegExp.hasMatch(widget.messages.msg.replaceAll(RegExp(r'\s+'), ''))
            ? const Text('              ')
            : Text(
          FormatTime.getFormatedTime(
              context: context, time: widget.messages.sent),
          style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 15.sp, color: colors.textColor2),
          ),
        ),
        SizedBox(width: 10.w),
        if (widget.messages.read.isNotEmpty)
          Icon(
            Icons.done_all_rounded,
            color: Colors.blue,
          ),
        Flexible(
          child: Container(
            padding: emojiRegExp.hasMatch(widget.messages.msg.replaceAll(RegExp(r'\s+'), ''))
                ? null
                : widget.messages.type == Type.text
                ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h)
                : null,
            margin: EdgeInsets.only(top: 10.h, right: 10.h, bottom: 10.h),
            decoration: BoxDecoration(
                color: emojiRegExp.hasMatch(widget.messages.msg.replaceAll(RegExp(r'\s+'), ''))
                    ? null
                    : const Color(0xff5061a0),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                    bottomLeft: Radius.circular(17))),
            child: GestureDetector(
              onTap: () {
                if (widget.messages.type == Type.image) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowImage(
                            user: widget.messages,
                          )));
                }
              },
              onLongPress: () {
                _showBottomDialog(context, colors.textColor2);
              },
              child: emojiRegExp.hasMatch(widget.messages.msg.replaceAll(RegExp(r'\s+'), ''))
                  ? Text(
                widget.messages.msg,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 45.sp,
                    color: colors.textColor,
                  ),
                ),
              )
                  : widget.messages.type == Type.text
                  ? Text(
                widget.messages.msg,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                    color: colors.textColor,
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.messages.msg,
                  placeholder: (context, url) => const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image,
                    size: 70,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _otherMessages() {
    if (widget.messages.read.isEmpty) {
      APIs.updateMessageStatus(widget.messages);
      print('read Successfully');
    }
    return Stack(
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                padding: emojiRegExp.hasMatch(widget.messages.msg)
                    ? null
                    : widget.messages.type == Type.text
                    ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h)
                    : null,
                margin: EdgeInsets.only(top: 10.h, left: 10.h, bottom: 10.h),
                decoration: BoxDecoration(
                    color: emojiRegExp.hasMatch(widget.messages.msg)
                        ? null
                        : const Color.fromARGB(255, 220, 245, 255),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(17),
                        bottomRight: Radius.circular(17),
                        bottomLeft: Radius.circular(17))),
                child: GestureDetector(
                  onTap: () {
                    if (widget.messages.type == Type.image) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowImage(
                                user: widget.messages,
                              )));
                    }
                  },
                  onLongPress: () {
                    _showBottomDialog(context, colors.textColor2);
                  },
                  child: emojiRegExp.hasMatch(widget.messages.msg)
                      ? Text(
                    widget.messages.msg,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 45.sp,
                        color: colors.textColor,
                      ),
                    ),
                  )
                      : widget.messages.type == Type.text
                      ? Text(
                    widget.messages.msg,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 17.sp,
                        color: colors.textColor2,
                      ),
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            emojiRegExp.hasMatch(widget.messages.msg.replaceAll(RegExp(r'\s+'), ''))
                ? const Text('              ')
                : Text(
              FormatTime.getFormatedTime(
                  context: context, time: widget.messages.sent),
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 15.sp,
                  color: colors.textColor2,
                ),
              ),
            ),
            SizedBox(width: 10.h),
          ],
        ),
        _buildEmojiAnimation(),
        _buildEffectAnimation(),
      ],
    );
  }

  Widget _buildEmojiAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_animationController.isAnimating) {
          return _buildEmojiAnimationContent();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildEmojiAnimationContent() {
    return Stack(
      children: _emojis
          .map((emoji) => Positioned(
        bottom: MediaQuery.of(context).size.height * _animationController.value +
            emoji.startPosition.dy * (1 - _animationController.value * 1),
        left: emoji.startPosition.dx +
            emoji.startPosition.dx * (1 - _animationController.value * 1),
        child: Transform.scale(
          scale: emoji.size * (1 + _animationController.value * .5),
          child: Text(
            '  ${emoji.emoji}  ',
            style: TextStyle(fontSize: emoji.size * 15),
          ),
        ),
      ))
          .toList(),
    );
  }

  Widget _buildEffectAnimation() {
    return AnimatedBuilder(
      animation: _effectAnimationController,
      builder: (context, child) {
        if (_effectAnimationController.isAnimating) {
          return _buildEffectAnimationContent();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildEffectAnimationContent() {
    return Stack(
      children: _effects
          .map((effect) => Positioned(
        bottom: MediaQuery.of(context).size.height * _effectAnimationController.value +
            effect.startPosition.dy * (1 - _effectAnimationController.value * 1),
        left: effect.startPosition.dx +
            effect.startPosition.dx * (1 - _effectAnimationController.value * 1),
        child: Transform.scale(
          scale: effect.size * (1 + _effectAnimationController.value * .5),
          child: Text(
            '  ${effect.effect}  ',
            style: TextStyle(fontSize: effect.size * 15),
          ),
        ),
      ))
          .toList(),
    );
  }

  _showBottomDialog(BuildContext context, Color color) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(10),
        ),
        builder: (_){
      return Container(
        height: 100.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                    onPressed: (){
                      if(widget.messages.type==Type.text){
                        FlutterClipboard.copy(widget.messages.msg).then((onValue)=>Messages.showSnackbar(context,'Copied Successfully'));
                        Navigator.pop(context);
                      }else{
                        GallerySaver.saveImage(widget.messages.msg,albumName: 'whisper').then((onValue)=>Messages.showSnackbar(context,'Image saved to Gallery'));
                        Navigator.pop(context);

                      }
                    },
                    icon: widget.messages.type==Type.text? Icon(Icons.copy,size: 35,color: colors.containerColor2,):
                    Icon(Icons.save_alt,size: 35,color: colors.containerColor2,)),
                widget.messages.type== Type.text? Text('Copy',style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor2,
                  ),
                ), ) :

                Text('Save',style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor2,
                  ),
                ), )
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: (){
                      if(APIs.users.uid==widget.messages.fromid) {
                        print('pinning message....');
                        APIs.pinMessage(widget.messages.toid, widget.messages.msg)
                            .then((onValue) =>
                            Messages.showSnackbar(
                                context, 'Pined Successfully'));
                        Navigator.pop(context);
                      }
                      else{
                        print('pinning message2....');
                        APIs.pinMessage(widget.messages.fromid, widget.messages.msg)
                            .then((onValue) =>
                            Messages.showSnackbar(
                                context, 'Pined Successfully'));
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.push_pin_outlined, size: 35,color: colors.containerColor2,)
                    ),
                Text('Pin',style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor2,
                  ),
                ), )
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      _showMessageUpdateDialog();
                    },
                    icon:Icon(Icons.edit,size: 35,color: colors.containerColor2,)),
                Text('Edit',style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor2,
                  ),
                ), )
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      _showMoreDialog();

                    },
                    icon:  Icon(Icons.menu,size: 35,color: colors.containerColor2,)),
                Text('More',style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor2,
                  ),
                ), )
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.messages.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: Row(
            children: [
              Icon(
                Icons.message,
                color: colors.containerColor2,
                size: 30,
              ),
              Text(' Update Message',style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: colors.textColor2,
              ),
        ),)
            ],
          ),

          //content
          content: TextFormField(
            initialValue: updatedMsg,

            maxLines: null,
            onChanged: (value) => updatedMsg = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child:  Text(
                  'Cancel'
                ,style: GoogleFonts.roboto(
                textStyle: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: colors.textColor2,
                ),
                ),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                  APIs.UpdateMessage(widget.messages, updatedMsg);
                },
                child:  Text(
                  'Update'
    ,style: GoogleFonts.roboto(
    textStyle: TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.bold,
    color: colors.textColor2,
    ),
    ),
                ))
          ],
        ));
  }

  void _showMoreDialog() {
    String updatedMsg = widget.messages.msg;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 15, right: 15, top: 20, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: Text(' More',style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: colors.containerColor1,
            ),
          ),),

          //content
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: (){},
                  child: Text('Forward',style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      color: colors.containerColor2,
                    ),
                  ),)
              ),
              TextButton(
                  onPressed: (){},
                  child: Text('Bump',style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      color: colors.containerColor2,
                    ),
                  ),)
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_)=>AlertDialog(
                          title: Text('Are you sure! you want to remove this message?',style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              // fontWeight: FontWeight.bold,
                              color: colors.containerColor1,
                            ),
                          ),),
                          content: TextButton.icon(
                              onPressed: (){
                                APIs.deleteMessage(widget.messages);
                                Navigator.pop(context);
                              },
                            icon: Icon(Icons.delete,size: 30,),

                              label: Text('Unsend for Everyone',style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colors.containerColor1,
                                ),
                              ),),
                          ),
                        ));
                  },
                  child: Text('Unsend',style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      color: colors.containerColor2,
                    ),
                  ),)
              ),
              TextButton(
                  onPressed: (){},
                  child: Text('Details',style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      color: colors.containerColor2,
                    ),
                  ),)
              ),
              TextButton(
                  onPressed: (){},
                  child: Text('Block',style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      color: colors.containerColor2,
                    ),
                  ),)
              ),
            ],
          ),

        ));
  }


}

class _AnimatedEmoji {
  final String emoji;
  final double size;
  final Offset startPosition;
  final UniqueKey key; // Use UniqueKey instead of GlobalKey
  final Duration animationDuration;

  _AnimatedEmoji({
    required this.emoji,
    required this.key, // UniqueKey instead of GlobalKey
    this.animationDuration = const Duration(seconds: 4), required BuildContext context,
  })  : size = Random().nextDouble() * 1.5 + 0.5,
        startPosition = Offset(
          Random().nextDouble() * 400,
          -Random().nextDouble() * 100,
        );
}

class _AnimatedEffect {
  final String effect;
  final double size;
  final Offset startPosition;
  final UniqueKey key; // Use UniqueKey instead of GlobalKey
  final Duration animationDuration;

  _AnimatedEffect({
    required this.effect,
    required this.key, // UniqueKey instead of GlobalKey
    this.animationDuration = const Duration(seconds: 4), required BuildContext context,
  })  : size = Random().nextDouble() * 1.5 + 0.5,
        startPosition = Offset(
          Random().nextDouble() * 400,
          -Random().nextDouble() * 100,
        );
}