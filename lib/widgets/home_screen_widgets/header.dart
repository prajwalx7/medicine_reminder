import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_reminder/screens/profile_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "How is your \nhealth today?",
            style: TextStyle(fontSize: 42.sp, fontFamily: 'prompt'),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(
                  color: Color(0xffC4DAD2), shape: BoxShape.circle),
              child: const Icon(
                Iconsax.user,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
