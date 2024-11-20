import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      appBar: AppBar(
        backgroundColor: const Color(0xffE9EFEC),
        title: const Text(
          "Profile",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xff16423C)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 150.h,
                width: 150.w,
                padding: EdgeInsets.all(18.r),
                decoration: const BoxDecoration(
                    color: Color(0xffC4DAD2), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "P",
                    style: TextStyle(
                        fontSize: 72.sp,
                        color: const Color(0xff16423C),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
