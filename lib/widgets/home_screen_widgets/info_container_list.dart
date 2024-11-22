import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InfoContainerList extends StatefulWidget {
  const InfoContainerList({super.key});

  @override
  InfoContainerListState createState() => InfoContainerListState();
}

class InfoContainerListState extends State<InfoContainerList> {
  final List<Map<String, String>> infoData = [
    {
      "title": "About Diseases",
      "description": "Learn about various \ndiseases and their \nsymptoms.",
      "image": "assets/svg/diseases.svg"
    },
    {
      "title": "About Medicines",
      "description": "Understand different \nmedicines and their uses.",
      "image": "assets/svg/medicines.svg"
    },
    {
      "title": "Locate Nearby Hospitals",
      "description": "Find hospitals and \nclinics near you.",
      "image": "assets/svg/hospital.svg"
    },
  ];

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: infoData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                child: infoContainer(context, infoData[index]),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0.h),
          child: SmoothPageIndicator(
            controller: _controller,
            count: infoData.length,
            effect: const ExpandingDotsEffect(
              dotWidth: 8,
              dotHeight: 8,
              spacing: 4,
              expansionFactor: 4,
              dotColor: Colors.grey,
              activeDotColor: Color(0xff16423C),
            ),
          ),
        ),
      ],
    );
  }

  Widget infoContainer(BuildContext context, Map<String, String> data) {
    return Container(
      width: 330.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: SvgPicture.asset(
              height: 200.h,
              width: 150.w,
              data['image']!,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title']!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'prompt'),
                ),
                SizedBox(height: 8.h),
                Text(
                  data['description']!,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16.sp,
                      fontFamily: 'kanit'),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Text(
                "View More",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontFamily: 'kanit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
