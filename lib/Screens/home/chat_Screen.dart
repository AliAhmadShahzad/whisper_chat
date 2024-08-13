import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/Screens/home/messages_screen.dart';
import 'package:whisper/helper/time_Formater.dart';

import 'package:whisper/models/chat_messages.dart';

import '../../Colors/colors.dart';
import '../../api/apis.dart';

import '../../models/chat_user_model.dart';

import '../../models/word_effect_models.dart';
import 'other_user_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel user;
  final String theme;
  final String emoji;
  const ChatScreen(
      {super.key,
      required this.user,
      required this.theme,
      required this.emoji});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<MessagesModel> _list = [];
  final _textController = TextEditingController();
  bool _emoji = false;
  bool _isUploading = false;
  bool _isTextPresent = false;
  bool _initializer = false;
  late AnimationController _animationController;
  late AnimationController _animationController1;
  late List<_AnimatedEmoji> _emojis = [];
  late List<_AnimatedEffect> _effect = [];
  late String currentTheme;
  late String currentEmoji;
  late List<WordEffectModels> wordEffect = [];

  RegExp emojiOnlyRegExp = RegExp(
    r'^[\u{1F300}-\u{1FAD6}\u{1F90D}-\u{1F9CF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}'
    r'\u{1F170}-\u{1F251}\u{1F004}-\u{1F0CF}\u{1F30D}-\u{1F567}\u{1F191}-\u{1F251}'
    r'\u{1F1E6}-\u{1F1FF}\u{1F300}-\u{1F5FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}'
    r'\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}'
    r'\u{2700}-\u{27BF}]+$', // Match only emojis
    unicode: true,
  );

  @override
  void initState() {
    super.initState();

    _initializeWordEffects();
    currentTheme = widget.theme;
    _fetchTheme();
    currentEmoji = widget.emoji;
    _fetchEmoji();

    if (!_initializer) {
      _initializeOnce();
      _initializer = true;
    }
    _textController.addListener(() {
      setState(() {
        _isTextPresent = _textController.text.isNotEmpty;
      });
    });
    _animationController = AnimationController(
      duration: Duration(seconds: 5), // Set the duration to 5 seconds
      vsync: this,
    );
    _animationController1 = AnimationController(
      duration: Duration(seconds: 5), // Set the duration to 5 seconds
      vsync: this,
    );
  }

  Future<void> _initializeWordEffects() async {
    wordEffect = await APIs.getAllWordEffects(widget.user);
  }

  Future<void> _initializeOnce() async {
    await APIs.setEmojiTheme(widget.user, currentEmoji, currentTheme);
    // Example: Fetch data, set up listeners, etc.
  }

  Future<void> _fetchTheme() async {
    String fetchedTheme = await APIs.getTheme(widget.user);
    setState(() {
      currentTheme = fetchedTheme;
    });
  }

  Future<void> _fetchEmoji() async {
    String fetchedEmoji = await APIs.getEmoji(widget.user);
    setState(() {
      currentEmoji = fetchedEmoji;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _animationController1.dispose();

    super.dispose();
  }

  void _startEmojiAnimation(String emoji) {
    _emojis = List.generate(
        40, (index) => _AnimatedEmoji(emoji: emoji, context: context));
    _animationController.reset();
    _animationController.forward();
  }

  void _startEffectAnimation(String effect) {
    _effect = List.generate(
        50, (index) => _AnimatedEffect(effect: effect, context: context));
    _animationController1.reset();
    _animationController1.forward();
  }

  void _checkAndAnimateEffects(String text) {
    print('in check and animate effect $text');
    for (var wordEffect in wordEffect) {
      print('word effect are: $wordEffect');
      if (text.toLowerCase().contains(wordEffect.word.toLowerCase())) {
        print('word effect are: $wordEffect');
        _startEffectAnimation(wordEffect.effect);
        return; // Exit loop after finding the first match
      }
      print('word effect are: $wordEffect');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 40.h),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (_emoji) {
              setState(() {
                _emoji = !_emoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OtherUserProfileScreen(user: widget.user)));
                  },
                  child: _appBar()),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(currentTheme), fit: BoxFit.cover),
                  ),
                ),
                GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: APIs.getAllMessages(widget.user),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              //if data is loading
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const SizedBox();

                              //if some or all data is loaded then show it
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _list = data
                                        ?.map((e) =>
                                            MessagesModel.fromJson(e.data()))
                                        .toList() ??
                                    [];
                                if (_list.isNotEmpty) {
                                  return ListView.builder(
                                    reverse: true,
                                    itemCount: _list.length,
                                    padding: EdgeInsets.only(top: 20.h),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return MessagesDisplayScreen(
                                        messages: _list[index],
                                        wordEffects: wordEffect,
                                        theme: widget.theme
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Say Hii! 👋',
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          color: colors.textColor2,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            }
                          },
                        ),
                      ),
                      if (_isUploading)
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )),
                      _chatInput(),
                      if (_emoji)
                        EmojiPicker(
                          textEditingController: _textController,
                          config: Config(
                              height: 256,
                              emojiViewConfig: EmojiViewConfig(
                                emojiSizeMax:
                                    28 * (Platform.isIOS ? 1.20 : 1.0),
                                columns: 9,
                              ),
                              searchViewConfig: SearchViewConfig(
                                  backgroundColor: Colors.transparent),
                              bottomActionBarConfig: BottomActionBarConfig(
                                  buttonColor: Colors.white,
                                  backgroundColor: Colors.grey.shade200,
                                  buttonIconColor: Colors.deepOrangeAccent)),
                        ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                _buildEmojiAnimation(),
                _buildEffectAnimation()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.only(top: 5.h),
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final list = snapshot.data?.docs
                  .map((doc) => ChatUserModel.fromJson(doc.data()))
                  .toList() ??
              [];

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    Icon(Icons.arrow_back, size: 30, color: colors.textColor2),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  height: 45.h,
                  fit: BoxFit.cover,
                  width: 45.w,
                  imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor2,
                        ),
                      ),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? "Online"
                              : FormatTime.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : FormatTime.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 17.sp,
                          color: colors.textColor2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call, color: colors.textColor2, size: 25),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _emoji = !_emoji;
                    });
                  },
                  icon: Icon(Icons.emoji_emotions_outlined,
                      color: colors.textColor2, size: 25),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onTap: () {
                      if (_emoji) {
                        setState(() {
                          _emoji = !_emoji;
                        });
                      }
                    },
                    // onSubmitted: (text){
                    //   // _checkAndAnimateEffects(text);
                    // },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle:
                          TextStyle(color: colors.textColor2, fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images =
                        await picker.pickMultiImage(limit: 5, imageQuality: 70);
                    for (var i in images) {
                      setState(() {
                        _isUploading = true;
                      });
                      await APIs.SendImageToChat(widget.user, File(i.path));
                      setState(() {
                        _isUploading = false;
                      });
                    }
                  },
                  icon: Icon(Icons.collections_outlined,
                      color: colors.textColor2, size: 25),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      setState(() {
                        _isUploading = true;
                      });
                      await APIs.SendImageToChat(widget.user, File(image.path));
                      setState(() {
                        _isUploading = false;
                      });
                    }
                  },
                  icon: Icon(Icons.camera_alt_outlined,
                      color: colors.textColor2, size: 25),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              if (_list.isEmpty) {
                APIs.sendmessageToNewUserFirstTime(
                    widget.user, _textController.text, Type.text);
              } else {
                APIs.sendMessages(widget.user, _textController.text, Type.text);
              }
              if (_textController.text.trim().length == 2 &&
                  _textController.text.contains(emojiOnlyRegExp)) {
                _startEmojiAnimation(_textController.text);
              }
              _checkAndAnimateEffects(_textController.text);

              _textController.clear();
            } else if (widget.emoji.isNotEmpty) {
              if (_list.isEmpty) {
                APIs.sendmessageToNewUserFirstTime(
                    widget.user, widget.emoji, Type.text);
              } else {
                APIs.sendMessages(widget.user, widget.emoji, Type.text);
              }
              _startEmojiAnimation(widget.emoji);
              _textController.clear();
            }
          },
          minWidth: 0,
          child: _isTextPresent
              ? Icon(
                  Icons.send,
                  color: colors.textColor2,
                  size: 30,
                )
              : Text(
                  currentEmoji,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 30.sp,
                      color: colors.containerColor2,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmojiAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_animationController.isAnimating) {
          return Stack(
            children: _emojis
                .map((emoji) => Positioned(
                      bottom: MediaQuery.of(context).size.height *
                              _animationController.value +
                          emoji.startPosition.dy *
                              (1 -
                                  _animationController.value *
                                      1), // Adjust the multiplier
                      left: emoji.startPosition.dx +
                          emoji.startPosition.dx *
                              (1 -
                                  _animationController.value *
                                      1), // Adjust the multiplier
                      child: Transform.scale(
                        scale: emoji.size *
                            (1 +
                                _animationController.value *
                                    .5), // Adjust the multiplier
                        child: Text(
                          '  ${emoji.emoji}  ', // Add spaces around the emoji
                          style: TextStyle(fontSize: emoji.size * 15),
                        ),
                      ),
                    ))
                .toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildEffectAnimation() {
    return AnimatedBuilder(
      animation: _animationController1,
      builder: (context, child) {
        if (_animationController1.isAnimating) {
          return Stack(
            children: _effect
                .map((effect) => Positioned(
                      bottom: MediaQuery.of(context).size.height *
                              _animationController1.value +
                          effect.startPosition.dy *
                              (1 -
                                  _animationController1.value *
                                      1), // Adjust the multiplier
                      left: effect.startPosition.dx +
                          effect.startPosition.dx *
                              (1 -
                                  _animationController1.value *
                                      1), // Adjust the multiplier
                      child: Transform.scale(
                        scale: effect.size *
                            (1 +
                                _animationController1.value *
                                    .5), // Adjust the multiplier
                        child: Text(
                          '  ${effect.effect}  ', // Add spaces around the emoji
                          style: TextStyle(fontSize: effect.size * 15),
                        ),
                      ),
                    ))
                .toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _AnimatedEmoji {
  final String emoji;
  final double size;
  final Offset startPosition;
  final BuildContext context;
  final Duration animationDuration;

  _AnimatedEmoji({
    required this.emoji,
    required this.context,
    this.animationDuration =
        const Duration(seconds: 4), // Adjust the duration here
  })  : size = Random().nextDouble() * 1.5 +
            0.5, // Random size between 0.5 and 2.0
        startPosition = Offset(
          Random().nextDouble() * 400, // Random horizontal start position
          -Random().nextDouble() * 100, // Start from just off-screen top
        );
}

class _AnimatedEffect {
  final String effect;
  final double size;
  final Offset startPosition;
  final BuildContext context;
  final Duration animationDuration;

  _AnimatedEffect({
    required this.effect,
    required this.context,
    this.animationDuration =
        const Duration(seconds: 4), // Adjust the duration here
  })  : size = Random().nextDouble() * 1.5 +
            0.5, // Random size between 0.5 and 2.0
        startPosition = Offset(
          Random().nextDouble() * 400, // Random horizontal start position
          -Random().nextDouble() * 100, // Start from just off-screen top
        );
}
