import 'package:MedTrack/screens/home_screen_wrapper.dart';
import 'package:MedTrack/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          SvgPicture.asset("assets/svg/start.svg", height: 400.h, width: 200.w),
          Text(
            "Welcome to MedTrack",
            style: TextStyle(
                color: const Color(0xff16423C),
                fontSize: 26.sp,
                fontFamily: 'prompt',
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            "Timely Reminders for a Healthier You.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20.sp,
              fontFamily: 'prompt',
            ),
          ),
          const Spacer(),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff16423C),
                    ),
                  ),
                )
              : const SizedBox(),
          loginButton(
              context, "Login in with Google", "assets/images/google.png",
              () async {
            setState(() {
              isLoading = true;
            });
            User? user = await _authService.signInWithGoogle();
            setState(() {
              isLoading = false;
            });
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
                  backgroundColor: Color(0xff16423C),
                  content: Text(
                    "Error Signing In with Google",
                    style: TextStyle(fontFamily: 'kanit', color: Colors.white),
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 50.h),
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
