import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/screens/home_screen_wrapper.dart';
import 'package:medicine_reminder/screens/otp_screeen.dart';

class MobileNumberScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();

  MobileNumberScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendOtp(BuildContext context) async {
    final phoneNumber = "+91${mobileController.text.trim()}";
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreenWrapper()));
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Verification failed ${e.message}")));
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                          phoneNumber: phoneNumber,
                          verificationId: verificationId,
                        )));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to send OTP: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset("assets/svg/start.svg",
                  height: 400.h, width: 200.w),
              Text(
                "Enter your Mobile Number",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'kanit'),
              ),
              SizedBox(height: 8.h),
              Text(
                "We will send an SMS with a verification code on this number",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                    fontFamily: 'prompt'),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                cursorColor: const Color(0xff16423C),
                style: TextStyle(
                    fontSize: 22.sp, color: Colors.black, fontFamily: 'kanit'),
                decoration: InputDecoration(
                  hintText: "10-digit number",
                  hintStyle:
                      TextStyle(color: Colors.grey[600], fontFamily: 'kanit'),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff16423C),
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                ),
                onPressed: () {
                  _sendOtp(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verify Number",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontFamily: 'kanit'),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
