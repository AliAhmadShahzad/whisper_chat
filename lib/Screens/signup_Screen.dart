import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/Screens/Splash_two.dart';

import '../Colors/colors.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isAnimate = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimationName;
  late Animation<Offset> _offsetAnimationEmail;
  late Animation<Offset> _offsetAnimationPassword;
  late Animation<Offset> _offsetAnimationConfirmPassword;
  late Animation<double> _opacityAnimationName;
  late Animation<double> _opacityAnimationEmail;
  late Animation<double> _opacityAnimationPassword;
  late Animation<double> _opacityAnimationConfirmPassword;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        _isAnimate = true;
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _offsetAnimationName = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );

    _offsetAnimationEmail = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.25, 0.5, curve: Curves.easeInOut),
      ),
    );

    _offsetAnimationPassword = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 0.75, curve: Curves.easeInOut),
      ),
    );

    _offsetAnimationConfirmPassword = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimationName = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimationEmail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.25, 0.5, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimationPassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 0.75, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimationConfirmPassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();


  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 40.h, bottom: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  height: _isAnimate ? 40.h : 5.h,
                  width: _isAnimate ? 250.w : 5.w,
                  duration: Duration(seconds: 1),
                  child: Center(
                    child: Text(
                      "Sign up to Whisper",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AnimatedContainer(
                  height: _isAnimate ? 50.h : 5.h,
                  width: _isAnimate ? 500.w : 5.w,
                  duration: Duration(seconds: 1),
                  child: Text(
                    "Get chatting with friends and family today by signing up for our chat app!",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: colors.textColor3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Name",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: colors.textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimationName,
                  child: FadeTransition(
                    opacity: _opacityAnimationName,
                    child: _buildTextFormField("Enter your Name", _nameController),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: colors.textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimationEmail,
                  child: FadeTransition(
                    opacity: _opacityAnimationEmail,
                    child: _buildTextFormField("Enter your email", _emailController),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: colors.textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimationPassword,
                  child: FadeTransition(
                    opacity: _opacityAnimationPassword,
                    child: _buildTextFormField("Enter your password", _passwordController, obscureText: true),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: colors.textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimationConfirmPassword,
                  child: FadeTransition(
                    opacity: _opacityAnimationConfirmPassword,
                    child: _buildTextFormField("Enter your password again", _confirmPasswordController, obscureText: true),
                  ),
                ),
                SizedBox(height: 40.h),
                _buildSignInButton(),
                SizedBox(height: 40.h),
                _buildLoginText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String hintText, TextEditingController controller, {bool obscureText = false}) {
    return SizedBox(
      height: 60.h,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
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

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Handle form submission here
        }
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
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Text(
            "Sign Up",
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


  Widget _buildLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
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
