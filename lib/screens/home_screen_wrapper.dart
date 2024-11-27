import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/pill_model.dart';
import 'package:medicine_reminder/screens/home_screen.dart';

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => HomeScreenWrapperState();
}

class HomeScreenWrapperState extends State<HomeScreenWrapper> {
  List<PillModel> pills = [];

  void _updatePills(List<PillModel> updatedPills) {
    setState(() {
      pills = updatedPills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      pills: pills,
      onPillsUpdated: _updatePills,
    );
  }
}
