import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_reminder/model/medicine_model.dart';
import 'package:medicine_reminder/services/alarm_service.dart';
import 'package:medicine_reminder/widgets/medicine_list.dart';

class CustomBottomSheet extends StatefulWidget {
  final Function(PillModel) onAddPill;
  const CustomBottomSheet({super.key, required this.onAddPill});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final int _selectedId = DateTime.now().millisecondsSinceEpoch;
  String _selectedType = 'pill';
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isNotificationEnabled = false;

  void _updateSelectedType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
            textScaler: const TextScaler.linear(0.9),
          ),
          child: Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff16423C),
              colorScheme: const ColorScheme.light(
                primary: Color(0xff16423C),
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteColor: const Color(0xff16423C),
                hourMinuteTextColor: Colors.white,
                dayPeriodColor: const Color(0xff16423C),
                dayPeriodTextColor: Colors.white,
                dialHandColor: const Color(0xff16423C),
                dialBackgroundColor: Colors.grey[200],
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _handleAddMedicine() {
    if (_nameController.text.isEmpty ||
        _dosageController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(fontFamily: 'kanit'),
          ),
          backgroundColor: Color(0xff16423C),
        ),
      );
      return;
    }

    final newPill = PillModel(
      id: _selectedId,
      type: _selectedType,
      name: _nameController.text,
      dosage: _dosageController.text,
      time: _timeController.text,
      isNotificationEnabled: _isNotificationEnabled,
    );

    // call alarm service if notifications are enabled
    if (_isNotificationEnabled && _selectedTime != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // schedule alarm
      AlarmService.scheduleAlarm(
        alarmTime: alarmTime,
        medicineName: newPill.name,
      );
    }

    widget.onAddPill(newPill);
    Navigator.pop(context);
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
            Center(
              child: Text(
                "Add New Medicine",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'prompt',
                  color: const Color(0xff16423C),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 250.h,
              decoration: BoxDecoration(
                color: const Color(0xff1B4543),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: MedicineList(
                onSelect: _updateSelectedType,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: const Color(0xff16423C),
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'kanit',
                          color: const Color(0xff16423C)),
                      decoration: InputDecoration(
                        labelText: "Medicine Name",
                        labelStyle: TextStyle(
                          color: const Color(0xff16423C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        prefixIcon:
                            const Icon(Iconsax.note, color: Color(0xff16423C)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: const Color(0xff16423C),
                      textInputAction: TextInputAction.next,
                      controller: _dosageController,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'kanit',
                          color: const Color(0xff16423C)),
                      decoration: InputDecoration(
                        labelText: "Dosage (e.g., 2 capsules or ml)",
                        labelStyle: TextStyle(
                          color: const Color(0xff16423C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: const Icon(Iconsax.health,
                            color: Color(0xff16423C)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: const Color(0xff16423C),
                      controller: _timeController,
                      readOnly: true,
                      onTap: _selectTime,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'kanit',
                          color: const Color(0xff16423C)),
                      decoration: InputDecoration(
                        labelText: "Time",
                        labelStyle: TextStyle(
                          color: const Color(0xff16423C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        prefixIcon:
                            const Icon(Iconsax.clock, color: Color(0xff16423C)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Enable Notification",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'kanit',
                          color: const Color(0xff16423C),
                        ),
                      ),
                      Switch(
                        value: _isNotificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isNotificationEnabled = value;
                          });
                        },
                        activeColor: const Color(0xff16423C),
                      ),
                    ],
                  ),
                ],
              ),
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
                onPressed: _handleAddMedicine,
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
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
