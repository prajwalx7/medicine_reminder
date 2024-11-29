import 'package:MedTrack/constant.dart';
import 'package:MedTrack/model/pill_model.dart';
import 'package:MedTrack/services/alarm_service.dart';
import 'package:MedTrack/widgets/home_screen_widgets/pill_container.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TabBarWidget extends StatefulWidget {
  final List<PillModel> pills;
  final Function(List<PillModel>) onPillsUpdated;

  const TabBarWidget({
    super.key,
    required this.pills,
    required this.onPillsUpdated,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  ScrollController controller = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _deletePill(BuildContext context, PillModel pill) async {
    AlarmService.cancelAlarm(pill.id);

    final updatedPills = List<PillModel>.from(widget.pills)..remove(pill);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
        PILLS_KEY, updatedPills.map((p) => p.toJson().toString()).toList());
    widget.onPillsUpdated(updatedPills);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pill.name} deleted'),
        backgroundColor: const Color(0xff6A9C89),
      ),
    );
  }

  void _markAsTaken(PillModel pill) async {
    try {
      await AlarmService.cancelAlarm(pill.id);

      setState(() {
        pill.isTaken = true;
      });

      final updatedPills = List<PillModel>.from(widget.pills);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setStringList(
        PILLS_KEY,
        updatedPills.map((p) => p.toJson().toString()).toList(),
      );

      widget.onPillsUpdated(updatedPills);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pill.name} marked as taken'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error while marking pill as taken: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final notTakenPills = widget.pills.where((pill) => !pill.isTaken).toList();
    final takenPills = widget.pills.where((pill) => pill.isTaken).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: const Color(0xff16423C),
                borderRadius: BorderRadius.circular(32),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicatorColor: const Color(0xff16423C),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kanit'),
              tabs: const [
                Tab(text: "To Take"),
                Tab(text: "Taken"),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Not taken pills
              notTakenPills.isEmpty
                  ? Center(
                      child: Text(
                        "No reminders scheduled",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey,
                            fontFamily: 'kanit'),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: FadingEdgeScrollView.fromScrollView(
                        gradientFractionOnStart: 0.1,
                        gradientFractionOnEnd: 0.1,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 60.h),
                          controller: controller,
                          itemCount: notTakenPills.length,
                          itemBuilder: (context, index) {
                            final pill = notTakenPills[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.0.w),
                              child: Slidable(
                                key: Key(pill.id.toString()),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SizedBox(width: 5.w),
                                    GestureDetector(
                                      onTap: () {
                                        _deletePill(context, pill);
                                      },
                                      child: _buildContainer(
                                        icon: Iconsax.trash,
                                        color: Colors.red.shade400,
                                        label: "Delete",
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    GestureDetector(
                                      onTap: () {
                                        _markAsTaken(pill);
                                      },
                                      child: _buildContainer(
                                        icon: Iconsax.tick_circle,
                                        color: Colors.green.shade400,
                                        label: "Taken",
                                      ),
                                    ),
                                  ],
                                ),
                                child: PillContainer(
                                  pill: pill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

              // Taken pills
              takenPills.isEmpty
                  ? Center(
                      child: Text(
                        "No pills marked as taken",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey,
                            fontFamily: 'kanit'),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: FadingEdgeScrollView.fromScrollView(
                        gradientFractionOnStart: 0.1,
                        gradientFractionOnEnd: 0.1,
                        child: ListView.builder(
                          controller: controller,
                          padding: EdgeInsets.only(bottom: 60.h),
                          itemCount: takenPills.length,
                          itemBuilder: (context, index) {
                            final pill = takenPills[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.0.w),
                              child: Slidable(
                                key: Key(pill.id.toString()),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.30,
                                  children: [
                                    SizedBox(width: 5.w),
                                    GestureDetector(
                                      onTap: () {
                                        _deletePill(context, pill);
                                      },
                                      child: _buildContainer(
                                        icon: Iconsax.trash,
                                        color: Colors.red.shade400,
                                        label: "Delete",
                                      ),
                                    ),
                                  ],
                                ),
                                child: PillContainer(
                                  pill: pill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainer({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 19.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: color,
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(height: 5.h),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'kanit',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
