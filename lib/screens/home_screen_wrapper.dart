import 'dart:convert';
import 'package:MedTrack/constant.dart';
import 'package:MedTrack/model/pill_model.dart';
import 'package:MedTrack/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var tempPill = prefs.getStringList(PILLS_KEY);
      print(tempPill);

      if (tempPill != null) {
        List<PillModel> previousPills = tempPill.map((p) {
          // Fix the format
          String fixedJsonString = p
              .replaceAllMapped(
                  RegExp(r'(\w+):'), (match) => '"${match[1]}":') // Quote keys
              .replaceAll("'", '"') // Replace single quotes with double quotes
              .replaceAll(', ', ',') // Remove extra spaces after commas
              .replaceAllMapped(RegExp(r'(:\s*)([a-zA-Z0-9]+)(,|\s|$)'),
                  (match) {
            // Ensure that string values like `pill`, `absb`, `ejsj` are wrapped in double quotes
            if (match.group(2) != null && !match.group(2)!.startsWith('"')) {
              return '${match.group(1)}"${match.group(2)}"${match.group(3)}';
            }
            return match.group(0)!;
          });

          // Print out the fixed JSON string for debugging
          print("Fixed JSON String: $fixedJsonString");

          // Decode the JSON string and ensure the correct types
          var decodedJson = jsonDecode(fixedJsonString);

          // Ensure `id` is an integer, not a string
          if (decodedJson['id'] is String) {
            decodedJson['id'] = int.parse(decodedJson['id']);
          }

          // Ensure `intTime` elements are integers (if they are not already)
          decodedJson['intTime'] = List<int>.from(decodedJson['intTime']
              .map((e) => e is int ? e : int.parse(e.toString())));

          return PillModel.fromJson(decodedJson);
        }).toList();

        setState(() {
          pills = previousPills;
        });
      }
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
