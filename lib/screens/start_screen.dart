import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/screens/home_screen.dart';
import 'package:medicine_reminder/model/medicine_model.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<PillModel> pills = [
      PillModel(
          id: 1,
          name: "Aspirin",
          dosage: "500mg",
          time: "8:00 AM",
          type: "pill"),
      PillModel(
          id: 2,
          name: "Paracetamol",
          dosage: "250mg",
          time: "12:00 PM",
          type: "pill",
          isNotificationEnabled: null),
    ];

    void onPillsUpdated(List<PillModel> updatedPills) {}

    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      body: Column(
        children: [
          SvgPicture.asset("assets/svg/start.svg", height: 400, width: 200),
          Text(
            "Take your medicine, on time, every time.",
            style: TextStyle(fontSize: 20.sp, color: const Color(0xff16423C)),
          ),
          const Spacer(),
          loginButton(
            context,
            "Login with Google",
            "assets/images/google.png",
            pills,
            onPillsUpdated,
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}

Widget loginButton(
  BuildContext context,
  String title,
  String imagePath,
  List<PillModel> pills,
  Function(List<PillModel>) onPillsUpdated,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 32.0.w),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              pills: pills,
              onPillsUpdated: onPillsUpdated,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff16423C),
          borderRadius: BorderRadius.circular(38.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).canvasColor.withOpacity(0.1),
              blurRadius: 10.r,
              spreadRadius: 5.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                height: 25.h,
                width: 25.w,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 15.w),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white, fontSize: 20.sp),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
