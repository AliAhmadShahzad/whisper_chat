import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/Screens/Splash_two.dart';
import 'package:whisper/Screens/signup_Screen.dart';

import '../Colors/colors.dart';
import '../api/apis.dart';
import '../authentication/reCaptcha.dart';
import '../messenger/messages.dart';
import 'home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      print("\nInternet check failed: $e");
      return false;
    }
  }

  Future<void> _handleGoogleBtn() async {
    Messages.showProgressbar(context);

    if (await _checkInternetConnectivity()) {
      _signInWithGoogle().then((user) async {
        Navigator.pop(context);
        if (user != null) {
          if((await  APIs.userExists())){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
          }
          else{
            await APIs.createUser().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen())),);
          }
        }
      });
    } else {
      Navigator.pop(context);
      Messages.showSnackbar(context, "No internet connection");
    }
  }
  Future<UserCredential?> _signInWithGoogle() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Messages.showSnackbar(context, "Google sign in canceled");
        return null; // The user canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      Messages.showSnackbar(context, "Something went Wrong during Google sign in");
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 70.h, bottom: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login to Whisper",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor2,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Welcome back! Sign in using your social media account or email to continue",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      color: colors.textColor3,
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon("assets/facebook.png"),
                    _buildSocialIcon("assets/google.png"),
                    _buildSocialIcon("assets/social.png"),
                  ],
                ),
                SizedBox(height: 30.h),
                Text(
                  "OR",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: colors.textColor2,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email",style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: colors.textColor2,
                          fontWeight: FontWeight.bold
                      ),
                    ),)),
                _buildTextFormField("Enter your email", _emailController),
                SizedBox(height: 30.h),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password",style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: colors.textColor2,
                          fontWeight: FontWeight.bold
                      ),
                    ),)),
                _buildTextFormField("Enter your password", _passwordController, obscureText: true),
                SizedBox(height: 60.h),
                _buildLoginButton(),
                SizedBox(height: 70.h),
                _buildSignUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imagePath) {
    return Container(
      width: 30.w,
      height: 30.h,
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
          onTap: (){
            if(imagePath == 'assets/google.png'){
              _handleGoogleBtn();
            }
          },
          child: Image.asset(imagePath)),
    );
  }

  Widget _buildTextFormField(String hintText, TextEditingController controller, {bool obscureText = false}) {
    return SizedBox(
      height: 70.h,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 20.h),
        ),
        obscureText: obscureText,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 17.sp,
            color: colors.containerColor1,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
      },
      child: Container(
        height: 60.h,
        width: 250.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              colors.containerColor1,
              colors.containerColor4,
            ],
          ),
        ),
        child: Center(
          child: Text(
            "Login",
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 15.sp,
              color: colors.textColor3,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: Text(
            'Sign Up',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 15.sp,
                color: Colors.blue,
              ),
            ),
          ),
        )
      ],
    );
  }
}
