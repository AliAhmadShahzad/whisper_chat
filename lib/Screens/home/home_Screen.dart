import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisper/Screens/Splash_two.dart';
import 'package:whisper/Screens/home/settings.dart';
import 'package:whisper/messenger/messages.dart';
import 'package:whisper/models/chat_user_model.dart';
import '../../Colors/colors.dart';
import '../../api/apis.dart';

import 'chat_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<ChatUserModel> list = [];
  final List<ChatUserModel> _search = [];
  static bool _isSearching = false;
  String? _image;
  int _selectedIndex = 0; // Index for selected bottom navigation tab
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeUserData();

    SystemChannels.lifecycle.setMessageHandler(
      (message) async {
        if (FirebaseAuth.instance.currentUser != null) {
          if (message.toString().contains('resume')) {
            APIs.updateActiveStatus(true);
          }
          if (message.toString().contains('pause')) {
            APIs.updateActiveStatus(false);
          }
        }
      },
    );
  }

  Future<void> _initializeUserData() async {
    await APIs.getselfInfo();
    setState(() {
      list = [APIs.userData]; // Assuming userData should be part of the list initially
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return Center(
            child:
                Text('Messages', style: GoogleFonts.roboto(fontSize: 20.sp)));
      case 2:
        return Center(
            child: Text('Calls', style: GoogleFonts.roboto(fontSize: 20.sp)));
      case 3:
        return _SettingScreen();
      default:
        return Center(child: Text('No content'));
    }
  }

  Widget _buildHomeScreen() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.sizeOf(context).height,
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
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                        });
                      },
                      icon: Icon(
                        !_isSearching ? Icons.search : Icons.clear,
                        size: 35,
                        color: colors.containerColor4,
                      )),
                  !_isSearching
                      ? Text(
                          "HOME",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: colors.textColor,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 200.w,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Search...",
                                hintStyle: TextStyle(color: colors.textColor),
                                border: InputBorder.none),
                            style: TextStyle(
                                color: colors.textColor, fontSize: 22.sp),
                            autofocus: true,
                            onChanged: (value) {
                              _search.clear();
                              for (var i in list) {
                                if ((i.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) ||
                                    (i.email
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))) {
                                  _search.add(i);
                                }
                                setState(() {
                                  _search;
                                });
                              }
                            },
                          ),
                        ),
                  // Check if the list is empty before accessing list[0]
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreenUser()));
                    },
                    child: Icon(Icons.more_vert,size: 35,
                      color: colors.containerColor4,),
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 50.h),
                  padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                  height: MediaQuery.sizeOf(context).height - 235.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: colors.textColor),
                  child: StreamBuilder(
                    stream: APIs.getMyUserId(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator(strokeWidth: 2));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          var userIds = snapshot.data!.docs.map((e) => e.id).toList() ?? [];
                          if (userIds.isEmpty) {
                            return Center(
                              child: Text(
                                "No Users Found! Please Add",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: colors.textColor2,
                                  ),
                                ),
                              ),
                            );
                          }
                          return StreamBuilder(
                            stream: APIs.getAllUnBlockUsers(userIds),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator(strokeWidth: 2));
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                var list = snapshot.data!.docs.map((doc) => ChatUserModel.fromJson(doc.data())).toList();
                                return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 20.h),
                                  itemCount: list.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatHome(user: list[index]);
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "No Connection Found",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: colors.textColor2,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _SettingScreen() {


    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
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
              // Check if the list is empty before accessing list[0]
              list.isNotEmpty
                  ? Stack(children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.file(
                                File(_image!),
                                width: 170.w,
                                height: 170.h,
                                // fit: BoxFit.fill,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: CachedNetworkImage(
                                height: 170.h,
                                width: 170.w,
                                fit: BoxFit.cover,
                                imageUrl: APIs.userData.image,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                builder: (context) {
                                  return ListView(
                                    shrinkWrap: true,
                                    padding:
                                    EdgeInsets.only(top: 20.h, bottom: 20.h),
                                    children: [
                                      Text(
                                        "Pick Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textColor2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                ImagePicker();
                                                final XFile? image =
                                                await picker.pickImage(
                                                    source:
                                                    ImageSource.gallery);
                                                if (image != null) {
                                                  setState(() {
                                                    _image = image.path;
                                                  });
                                                  APIs.updateProfilePicture(
                                                      File(_image!));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(150.w, 150.h)),
                                              child: Image.asset(
                                                  'assets/image.png')),
                                          ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                ImagePicker();
                                                final XFile? photo =
                                                await picker.pickImage(
                                                    source:
                                                    ImageSource.camera);
                                                if (photo != null) {
                                                  setState(() {
                                                    _image = photo.path;
                                                  });
                                                  APIs.updateProfilePicture(
                                                      File(_image!));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(150.w, 150.h)),
                                              child: Image.asset(
                                                  'assets/camera.png'))
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },

                          shape: CircleBorder(),
                          color: colors.textColor,
                          child: Icon(
                            Icons.edit,
                            color: colors.containerColor4,
                          ),
                        ),
                      )
                    ])
                  :
                    Container(
                    height: 170.h,
                    width: 170.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: CircleAvatar(
                        child: Icon(Icons.person,size: 90,),
                      ),
                  ),

              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.only(top: 30.h),
                  padding: EdgeInsets.only(top: 35.h, left: 20.h, right: 20.h),
                  height: MediaQuery.sizeOf(context).height - 327.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: colors.textColor,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: APIs.userData.name,
                        onSaved: (val) => APIs.userData.name = val ?? "",
                        validator: (val) => val != null || val!.isNotEmpty
                            ? null
                            : "Name Required",
                        decoration: InputDecoration(
                          labelText: 'Display Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: colors.containerColor4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextFormField(
                        initialValue: APIs.userData.email,
                        onSaved: (val) => APIs.userData.email = val ?? "",
                        validator: (val) => val != null || val!.isNotEmpty
                            ? null
                            : "Email Required",
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: colors.containerColor4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextFormField(
                        initialValue: APIs.userData.lastMessage,
                        onSaved: (val) => APIs.userData.lastMessage = val ?? "",
                        validator: (val) => val != null || val!.isNotEmpty
                            ? null
                            : "Field Required",
                        decoration: InputDecoration(
                          labelText: 'About',
                          prefixIcon: Icon(
                            Icons.info_outline,
                            color: colors.containerColor4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextFormField(
                        initialValue: APIs.userData.createdAt,
                        decoration: InputDecoration(
                          labelText: 'CreatedAt',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: colors.containerColor4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              APIs.updateUserInfo().then(
                                (value) => Messages.showSnackbar(
                                    context, 'Profile Updated Successfully'),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.containerColor4,
                          ),
                          icon: Icon(
                            Icons.edit,
                            color: colors.textColor,
                          ),
                          label: Text(
                            "Update",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textColor,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            Messages.showProgressbar(context);
                            APIs.updateActiveStatus(false);
                            await APIs.auth.signOut().then(
                              (value) async {
                                await GoogleSignIn().signOut().then(
                                  (value) {
                                    // Navigator.pop(context);
                                    Navigator.pop(context);
                                    APIs.auth = FirebaseAuth.instance;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SplashTwoScreen()));
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(
                            Icons.exit_to_app_outlined,
                            color: colors.textColor,
                          ),
                          label: Text(
                            "LogOut",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textColor,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isSearching) {
          setState(() {
            _isSearching = !_isSearching;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: colors.containerColor1,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
              backgroundColor: colors.containerColor2,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
              backgroundColor: colors.containerColor3,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: colors.containerColor4,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addUserDialog(colors.textColor2);
          },
          child: Icon(Icons.add),
          backgroundColor: colors.containerColor4,
        ),
      ),
    );
  }

  void _addUserDialog(Color color) {
    String email = '';
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
                    Icons.person_add_alt,
                    size: 30,
                    color: color,
                  ),
                  Text(
                    ' Add User',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor2,
                      ),
                    ),
                  ),
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(fontSize: 13),
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
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          color: colors.textColor2,
                        ),
                      ),
                    )),

                //update button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Messages.showSnackbar(
                                context, "User Doesn't Exist");
                          }
                        });
                      }
                      ;
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          color: colors.textColor2,
                        ),
                      ),
                    ))
              ],
            ));
  }
}

