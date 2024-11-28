import 'package:MedTrack/model/pill_model.dart';
import 'package:MedTrack/widgets/bottom_sheet_widgets/custom_bottom_sheet.dart';
import 'package:MedTrack/widgets/home_screen_widgets/header.dart';
import 'package:MedTrack/widgets/home_screen_widgets/info_container_list.dart';
import 'package:MedTrack/widgets/home_screen_widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final List<PillModel> pills;
  final Function(List<PillModel>) onPillsUpdated;

  const HomeScreen({
    super.key,
    required this.pills,
    required this.onPillsUpdated,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EFEC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff16423C),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: const Color(0xffE9EFEC),
            isScrollControlled: true,
            isDismissible: false,
            showDragHandle: true,
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.92,
                child: CustomBottomSheet(
                  onAddPill: (pill) {
                    final updatedPills = List<PillModel>.from(widget.pills)
                      ..add(pill);
                    widget.onPillsUpdated(updatedPills);
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            SizedBox(height: 15.h),
            const InfoContainerList(),
            SizedBox(height: 15.h),
            Expanded(
              child: TabBarWidget(
                pills: widget.pills,
                onPillsUpdated: widget.onPillsUpdated,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
