import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${DateFormat.MMMM().format(_currentDate)} ${_currentDate.year}",
      style: TextStyle(
        fontSize: 22.sp,
        color: const Color(0xff16423C),
      ),
    );
  }
}
