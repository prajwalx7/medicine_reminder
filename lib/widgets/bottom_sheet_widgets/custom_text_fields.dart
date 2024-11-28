import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final List<TextEditingController> timeControllers;
  final List<TimeOfDay?> selectedTimes;
  final List<bool> selectedDays;
  final timeCB;

  const CustomTextFields({
    super.key,
    required this.nameController,
    required this.dosageController,
    required this.timeControllers,
    required this.selectedTimes,
    required this.selectedDays,
    required this.timeCB,
  });

  @override
  State<CustomTextFields> createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  bool _isDailySelected = false;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String selectedUnit = 'pills';

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTimes[index] ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff16423C),
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
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      widget.timeCB(picked, index);
      setState(() {
        widget.selectedTimes[index] = picked;
        final hour = picked.hourOfPeriod;
        final minute = picked.minute.toString().padLeft(2, '0');
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        widget.timeControllers[index].text = '$hour:$minute $period';
      });
    }
  }

  void _toggleDaily(bool value) {
    setState(() {
      _isDailySelected = value;
      for (int i = 0; i < widget.selectedDays.length; i++) {
        widget.selectedDays[i] = value;
      }
    });
  }

  void _toggleDay(int index) {
    setState(() {
      widget.selectedDays[index] = !widget.selectedDays[index];
      _isDailySelected = widget.selectedDays.every((day) => day);
    });
  }

  Widget _buildTimeField(int index) {
    return Container(
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
        controller: widget.timeControllers[index],
        readOnly: true,
        onTap: () => _selectTime(index),
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'kanit',
          color: const Color(0xff16423C),
        ),
        decoration: InputDecoration(
          labelText: "Time ${index + 1}",
          labelStyle: TextStyle(
            color: const Color(0xff16423C),
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          prefixIcon: const Icon(Iconsax.clock, color: Color(0xff16423C)),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: EdgeInsets.all(15.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kanit',
                  color: const Color(0xff16423C),
                ),
              ),
              Switch(
                value: _isDailySelected,
                onChanged: (value) => _toggleDaily(value),
                activeColor: const Color(0xff16423C),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(
              _days.length,
              (index) => FilterChip(
                label: Text(
                  _days[index],
                  style: TextStyle(
                    color: widget.selectedDays[index]
                        ? Colors.white
                        : const Color(0xff16423C),
                    fontFamily: 'kanit',
                  ),
                ),
                selected: widget.selectedDays[index],
                onSelected: (bool selected) => _toggleDay(index),
                backgroundColor: Colors.white,
                selectedColor: const Color(0xff16423C),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                    color: const Color(0xff16423C),
                    width: 1.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          // Medicine Name
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
              controller: widget.nameController,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'kanit',
                color: const Color(0xff16423C),
              ),
              decoration: InputDecoration(
                labelText: "Medicine Name",
                labelStyle: TextStyle(
                  color: const Color(0xff16423C),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
                prefixIcon: const Icon(Iconsax.note, color: Color(0xff16423C)),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              ),
            ),
          ),
          SizedBox(height: 15.h),

          // Dosage
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
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
                    controller: widget.dosageController,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'kanit',
                      color: const Color(0xff16423C),
                    ),
                    decoration: InputDecoration(
                      labelText: "Dosage",
                      labelStyle: TextStyle(
                        color: const Color(0xff16423C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      prefixIcon: const Icon(
                        Iconsax.health,
                        color: Color(0xff16423C),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUnit = newValue!;
                        });
                       
                      },
                      items: ["pills", "capsules", "ml", "mg", "syringe"]
                          .map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(
                            unit,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'kanit',
                              color: const Color(0xff16423C),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "*select at least one time",
              style: TextStyle(
                  fontSize: 12.sp, color: Colors.black54, fontFamily: 'kanit'),
            ),
          ),
          SizedBox(height: 5.h),
          // Time Fields
          ...List.generate(
            widget.selectedTimes.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: _buildTimeField(index),
            ),
          ),
          SizedBox(height: 15.h),

          // Day Selector
          _buildDaySelector(),
        ],
      ),
    );
  }
}
