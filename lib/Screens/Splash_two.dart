import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http; // Add this for internet checking
import 'package:whisper/Screens/home/home_Screen.dart';
import 'package:whisper/Screens/login_screen.dart';
import 'package:whisper/Screens/signup_Screen.dart';
import '../Colors/colors.dart';
import '../api/apis.dart';
import '../messenger/messages.dart';

class SplashTwoScreen extends StatefulWidget {
  const SplashTwoScreen({super.key});

  @override
  State<SplashTwoScreen> createState() => _SplashTwoScreenState();
}

class _SplashTwoScreenState extends State<SplashTwoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;
  late Animation<double> _animation6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animation1 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.85, 1.0, curve: Curves.bounceOut)),
    );
    _animation2 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.7, 1.0, curve: Curves.bounceOut)),
    );
    _animation3 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.55, 1.0, curve: Curves.bounceOut)),
    );
    _animation4 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.4, 1.0, curve: Curves.bounceOut)),
    );
    _animation5 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.25, 1.0, curve: Curves.bounceOut)),
    );
    _animation6 = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.1, 1.0, curve: Curves.bounceOut)),
    );

    Future.delayed(Duration.zero, () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check internet connectivity using an HTTP request
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
        await APIs.createUser();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
        }
        }
      });
    } else {
      Navigator.pop(context);
      Messages.showSnackbar(context, "No internet connection");
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
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
    } catch (e) {
      print("\nGoogle sign in error: $e");
      Messages.showSnackbar(context, "Something went wrong during Google sign in");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        padding: EdgeInsets.only(left: 15, right: 15, top: 70, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation1,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation1.value),
                  child: child,
                );
              },
              child: Text(
                "Connect friends easily & quickly",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 70.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AnimatedBuilder(
              animation: _animation2,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation2.value),
                  child: child,
                );
              },
              child: Text(
                "Our chat app is the perfect way to stay connected with friends and family.",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    color: colors.textColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            AnimatedBuilder(
              animation: _animation3,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation3.value),
                  child: child,
                );
              },
              child: _buildSocialIcons(),
            ),
            SizedBox(height: 25.h),
            AnimatedBuilder(
              animation: _animation4,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation4.value),
                  child: child,
                );
              },
              child: Text(
                "OR",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: colors.textColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            AnimatedBuilder(
              animation: _animation5,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation5.value),
                  child: child,
                );
              },
              child: _buildSignUpButton(),
            ),
            SizedBox(height: 50.h),
            AnimatedBuilder(
                animation: _animation6,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation6.value),
                    child: child,
                  );
                },
                child: _buildLoginText()),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon("assets/facebook.png"),
        _buildSocialIcon("assets/google.png"),
        _buildSocialIcon("assets/social.png"),
      ],
    );
  }

  Widget _buildSocialIcon(String imagePath) {
    return GestureDetector(
      onTap: () {
        if (imagePath == 'assets/google.png') {
          _handleGoogleBtn();
        }
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: Container(
        height: 50.h,
        width: 330.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Sign Up With email",
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 15.sp,
                color: colors.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 15.sp,
              color: colors.textColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            'Login',
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
