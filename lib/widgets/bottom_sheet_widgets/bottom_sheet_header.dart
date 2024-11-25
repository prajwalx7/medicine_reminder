import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetHeader extends StatefulWidget {
  final Function(String) onSelect;

  const BottomSheetHeader({super.key, required this.onSelect});

  @override
  BottomSheetHeaderState createState() => BottomSheetHeaderState();
}

class BottomSheetHeaderState extends State<BottomSheetHeader> {
  int _currentPage = 0;

  final List<Map<String, String>> medicines = [
    {"svgPath": "assets/svg/pill.svg", "type": "pill"},
    {"svgPath": "assets/svg/capsule.svg", "type": "capsule"},
    {"svgPath": "assets/svg/liquid.svg", "type": "liquid"},
    {"svgPath": "assets/svg/syringe.svg", "type": "syringe"},
  ];

  final PageController _pageController = PageController(viewportFraction: 0.65);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Add New Medicine",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'prompt',
              color: const Color(0xff16423C),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          height: 250.h,
          decoration: BoxDecoration(
            color: const Color(0xff1B4543),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: SizedBox(
            height: 200.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: medicines.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                widget.onSelect(medicines[index]['type']!);
              },
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                bool isSelected = _currentPage == index;
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: isSelected ? 10 : 20),
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.amber : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        medicine['type']!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'prompt'),
                      ),
                      SizedBox(height: 15.h),
                      SvgPicture.asset(
                        medicine['svgPath']!,
                        height: 80.h,
                        width: 80.w,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
