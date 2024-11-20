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
      decoration: BoxDecoration(
        color: const Color(0xffE9EFEC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff16423C), width: 0.4),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
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
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 5.h),
                // Dosage text
                Text(
                  pill.dosage,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
