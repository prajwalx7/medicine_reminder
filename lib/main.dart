import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/screens/home_screen_wrapper.dart';
import 'package:medicine_reminder/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    final permission = await Permission.notification.request();
    if (permission.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicine Reminder',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.amber,
            selectionHandleColor: Color(0xff16423C),
          ),
          primaryColor: const Color(0xff16423C),
          scaffoldBackgroundColor: const Color(0xffE9EFEC),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
