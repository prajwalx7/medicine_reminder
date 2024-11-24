import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_reminder/model/medicine_model.dart';

class PillContainer extends StatelessWidget {
  final PillModel pill;

  const PillContainer({super.key, required this.pill});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Container(
              height: 60.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: const Color(0xffC4DAD2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  'assets/svg/${pill.type}.svg',
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pill.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'zen',
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff16423C),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    pill.dosage,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'kanit',
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Iconsax.clock,
                  color: const Color(0xff16423C),
                  size: 20.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  pill.time,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'kanit',
                    color: const Color(0xff16423C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
