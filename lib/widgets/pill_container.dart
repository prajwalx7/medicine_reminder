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
      decoration: BoxDecoration(
        color: const Color(0xffC4DAD2),
        borderRadius: BorderRadius.horizontal(
            right: Radius.circular(15.r), left: Radius.circular(15.r)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffE9EFEC),
            ),
            child: SvgPicture.asset(
              'assets/svg/${pill.type}.svg',
              height: 60.h,
              width: 60.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            // Use Expanded to allow Column to take the remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dosage text
                Text(
                  pill.dosage,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 5.h),
                // Medicine name text
                Text(
                  pill.name,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 5.h),
                // Time text
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 18.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      pill.time,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
