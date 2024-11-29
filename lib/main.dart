import 'dart:io';
import 'package:MedTrack/screens/home_screen_wrapper.dart';
import 'package:MedTrack/screens/login_screen.dart';
import 'package:MedTrack/services/auth_service.dart';
import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp();
  bool loggedIn = await AuthService.isLoggedIn();

  if (Platform.isAndroid) {
    await Permission.notification.request();
  }
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MedTrack',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.amber,
            selectionHandleColor: Color(0xff16423C),
          ),
          primaryColor: const Color(0xff16423C),
          scaffoldBackgroundColor: const Color(0xffE9EFEC),
        ),
        home: loggedIn ? const HomeScreenWrapper() : const LoginScreen(),
      ),
    );
  }
}
