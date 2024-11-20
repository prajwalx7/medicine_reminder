import 'package:flutter/material.dart';
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

  // PageController to manage the PageView and the current page index
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: infoData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: infoContainer(context, infoData[index]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
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
      width: 330,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
              height: 200,
              width: 150,
              data['image']!,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title']!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['description']!,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "View More",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
