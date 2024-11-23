import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/screens/home_screen_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
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
          primaryColor: const Color(0xff16423C),
          scaffoldBackgroundColor: const Color(0xffE9EFEC),
        ),
        home: const HomeScreenWrapper(),
      ),
    );
  }
}
