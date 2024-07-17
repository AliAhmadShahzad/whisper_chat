import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ReCaptcha {
  static Future getVerificationToken() async {
    try {
      // Get the current Firebase Auth instance
      final auth = FirebaseAuth.instance;

      // Verify the user's identity using reCAPTCHA v3
      final reCaptchaToken = await auth.verifyPhoneNumber(
        phoneNumber: '+923090022121', // Provide a dummy phone number since it's not used
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('reCAPTCHA verification failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: 0,
        timeout: const Duration(seconds: 60),
      );

      return reCaptchaToken;
    } catch (e) {
      print('Error getting reCAPTCHA token: $e');
      return null;
    }
  }
}
