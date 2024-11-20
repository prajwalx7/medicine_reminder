import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedicineList extends StatefulWidget {
  final Function(String) onSelect;

  const MedicineList({super.key, required this.onSelect});

  @override
  MedicineListState createState() => MedicineListState();
}

class MedicineListState extends State<MedicineList> {
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
    return SizedBox(
      height: 200.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: medicines.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          widget.onSelect(medicines[index]
              ['type']!); 
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
                  ),
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
    );
  }
}
