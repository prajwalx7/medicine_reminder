import 'package:MedTrack/constant.dart';
import 'package:MedTrack/model/pill_model.dart';
import 'package:MedTrack/services/alarm_service.dart';
import 'package:MedTrack/widgets/bottom_sheet_widgets/bottom_sheet_header.dart';
import 'package:MedTrack/widgets/bottom_sheet_widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomSheet extends StatefulWidget {
  final Function(PillModel) onAddPill;
  const CustomBottomSheet({super.key, required this.onAddPill});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  List<TextEditingController> timeControllers = [];
  String _selectedType = 'pill';
  final List<TimeOfDay?> _selectedTimes = [null, null, null];
  final List<int> _intTime = [0, 0, 0];
  String selectedUnit = 'pills';

  final List<bool> _selectedDays = List.generate(7, (index) => false);

  @override
  void initState() {
    super.initState();
    timeControllers = List.generate(3, (index) => TextEditingController());
  }

  Future<void> _addMedicine() async {
    print("pressed");
    if (_nameController.text.isEmpty ||
        _dosageController.text.isEmpty ||
        timeControllers.every((controller) => controller.text.isEmpty) ||
        (!_selectedDays.contains(true))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill required fields and select at least one day',
            style: TextStyle(fontFamily: 'kanit'),
          ),
          backgroundColor: Color(0xff16423C),
        ),
      );
      return;
    }

    final selectedTimes = timeControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toList();

    print("time : ${selectedTimes}");

    final int pillId = DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF;

    final newPill = PillModel(
        id: pillId,
        type: _selectedType,
        name: _nameController.text,
        dosage: _dosageController.text,
        unit: selectedUnit,
        selectedDays: _selectedDays,
        intTime: _intTime);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var tempPills = prefs.getStringList(PILLS_KEY);
    var pills = [];
    if (tempPills != null) {
      pills = tempPills;
    }
    print("new pill : ${newPill.toJson().toString()}");
    await prefs
        .setStringList(PILLS_KEY, [newPill.toJson().toString(), ...pills]);

    for (int i = 0; i < _selectedTimes.length; i++) {
      if (_selectedTimes[i] != null) {
        for (int dayIndex = 0; dayIndex < _selectedDays.length; dayIndex++) {
          if (_selectedDays[dayIndex]) {
            final now = DateTime.now();
            final alarmTime = DateTime(
              now.year,
              now.month,
              now.day,
              _selectedTimes[i]!.hour,
              _selectedTimes[i]!.minute,
            );

            AlarmService.scheduleAlarm(
              pillId: pillId,
              alarmTime: alarmTime,
              medicineName: newPill.name,
              dayOfWeek: dayIndex + 1,
            );
          }
        }
      }
    }

    widget.onAddPill(newPill);
    Navigator.pop(context);
  }

  void _updateSelectedType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  int timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
            now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute)
        .microsecondsSinceEpoch;
  }

  void _onUnitChanged(String unit) {
    setState(() {
      selectedUnit = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 0.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomSheetHeader(onSelect: _updateSelectedType),
            SizedBox(height: 20.h),
            CustomTextFields(
              nameController: _nameController,
              dosageController: _dosageController,
              timeControllers: timeControllers,
              selectedTimes: _selectedTimes,
              onUnitChanged: _onUnitChanged,
              selectedDays: _selectedDays,
              timeCB: (TimeOfDay time, index) {
                _intTime[index] = timeOfDayToDateTime(time);
              },
            ),
            SizedBox(height: 30.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff16423C),
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: _addMedicine,
                child: Text(
                  "Add Medicine",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: 'kanit',
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    for (var controller in timeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
