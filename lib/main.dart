import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/model/medicine_model.dart';
import 'package:medicine_reminder/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PillModel> pills = [];

  void _updatePills(List<PillModel> updatedPills) {
    setState(() {
      pills = updatedPills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, index) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicine Reminder',
        home: HomeScreen(
          pills: pills,
          onPillsUpdated: _updatePills,
        ),
      ),
    );
  }
}
