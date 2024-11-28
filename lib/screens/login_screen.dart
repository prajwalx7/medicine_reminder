import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/screens/home_screen_wrapper.dart';
import 'package:medicine_reminder/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          SvgPicture.asset("assets/svg/start.svg", height: 400.h, width: 200.w),
          const Spacer(),
          loginButton(context, "Login with Google", "assets/images/google.png",
              () async {
            User? user = await _authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreenWrapper(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error Signing In with Google"),
                ),
              );
            }
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

Widget loginButton(
    BuildContext context, String title, String imagePath, VoidCallback? onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 32.0.w),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff16423C),
            borderRadius: BorderRadius.circular(38.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).canvasColor.withOpacity(0.1),
                blurRadius: 10.r,
                spreadRadius: 5.r,
              )
            ]),
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
                style: TextStyle(
                    fontSize: 18.sp, color: Colors.white, fontFamily: 'prompt'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
