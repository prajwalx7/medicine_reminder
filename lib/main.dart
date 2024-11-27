import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_reminder/model/pill_model.dart';
import 'package:medicine_reminder/screens/mobile_number_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(PillModelAdapter());
  await Hive.openBox<PillModel>('pillBox');

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
        home: MobileNumberScreen(),
      ),
    );
  }
}
