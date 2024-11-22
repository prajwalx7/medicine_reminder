import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_reminder/model/medicine_model.dart';
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
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff16423C),
            colorScheme: const ColorScheme.light(
              primary: Color(0xff16423C),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
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
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  TextField(
                    cursorColor: const Color(0xff16423C),
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color(0xff16423C),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kanit',
                      ),
                      labelText: "Medicine Name",
                      prefixIcon: Icon(Iconsax.note, color: Color(0xff16423C)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff16423C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  TextField(
                    textInputAction: TextInputAction.next,
                    cursorColor: const Color(0xff16423C),
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color(0xff16423C),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kanit',
                      ),
                      labelText: "Dosage (e.g., 2 capsules or ml)",
                      prefixIcon:
                          Icon(Iconsax.health, color: Color(0xff16423C)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff16423C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  TextField(
                    cursorColor: const Color(0xff16423C),
                    controller: _timeController,
                    readOnly: true,
                    onTap: _selectTime,
                    decoration: const InputDecoration(
                      labelText: "Time",
                      labelStyle: TextStyle(
                        color: Color(0xff16423C),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kanit',
                      ),
                      prefixIcon: Icon(Iconsax.clock, color: Color(0xff16423C)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff16423C)),
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
