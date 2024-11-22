// Screen 2: OTP Verification
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/screens/home_screen_wrapper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is initialized
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // Dispose the FocusNode to avoid memory leaks
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'prompt',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Please enter the 6-digit OTP sent to your mobile number",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontFamily: 'kanit',
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  widget.phoneNumber,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff16423C),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'kanit',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            PinCodeTextField(
              cursorColor: const Color(0xff16423C),
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              controller: otpController,
              focusNode: _focusNode,
              autoFocus: true,
              textStyle: TextStyle(
                  fontSize: 18.sp, color: Colors.black, fontFamily: 'kanit'),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8.0),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.grey[300],
                inactiveFillColor: Colors.white,
                activeColor: const Color(0xff16423C),
                selectedColor: Colors.greenAccent,
                inactiveColor: Colors.grey[400],
              ),
              onChanged: (value) {},
              enableActiveFill: true,
            ),
            SizedBox(height: 16.h),
            Text(
              "Didn't receive OTP? Resend OTP in 60s",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'kanit',
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff16423C),
                padding: EdgeInsets.symmetric(vertical: 16.0.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenWrapper(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontFamily: 'kanit',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
