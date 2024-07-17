import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/Splash_two.dart';

import '../Colors/colors.dart';
import 'home/home_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    // Delay animation and navigation
    Future.delayed(Duration(milliseconds: 2000), () {

      if(FirebaseAuth.instance.currentUser != null){
        print("\nUser: ${FirebaseAuth.instance.currentUser}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SplashTwoScreen()));
      }
      setState(() {
        _isAnimate = true;
      });
    });
    // Navigate to the next screen after 3 seconds
    Future.delayed(Duration(milliseconds: 3500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashTwoScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),
          // Animated image position
          AnimatedPositioned(
            top: 300.h,
            right: _isAnimate ? 90.w : -20.w,
            width: _isAnimate ? 250.w : 10.w,
            height: _isAnimate ? 250.h : 10.h,
            duration: Duration(milliseconds: 1000),
            child: Image.asset('assets/meetme.png', fit: BoxFit.contain),
          ),
          AnimatedPositioned(
            top: 700.h,
            right: _isAnimate ? 90.w : -20.w,
            width: _isAnimate ? 250.w : 10.w,
            height: _isAnimate ? 300.h : 10.h,
            duration: Duration(milliseconds: 1000),
            child: Text("Welcome to Whisper",style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),)
          ),
        ],
      ),
    );
  }
}
