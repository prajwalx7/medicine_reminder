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
      padding: EdgeInsets.all(8.r),
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 3),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ]),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffC4DAD2),
            ),
            child: SvgPicture.asset(
              'assets/svg/${pill.type}.svg',
              height: 60.h,
              width: 60.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pill.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'zen',
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 5.h),
                Text(
                  pill.dosage,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:
                      const TextStyle(fontFamily: 'kanit', color: Colors.grey),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0.w),
            child: Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: 18.sp,
                ),
                SizedBox(width: 3.w),
                Text(
                  pill.time,
                  style: TextStyle(fontSize: 20.sp, fontFamily: 'kanit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
