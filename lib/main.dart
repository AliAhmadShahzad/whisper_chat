import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/Screens/splash_Screen.dart';
import 'package:firebase_performance/firebase_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // final FirebasePerformance performance = FirebasePerformance.instance;

  // Enable performance monitoring (optional)
  // await performance.setPerformanceCollectionEnabled(true);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then(
    (value) {
      Firebase.initializeApp(
      );
      runApp(ChatterBox());
    },
  );
}


class ChatterBox extends StatelessWidget {
  const ChatterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 892),
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        title: "ChatterBox",
        home: SplashScreen(),
      ),
    );
  }
}
