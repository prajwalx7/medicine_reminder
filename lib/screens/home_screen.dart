import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_reminder/model/medicine_model.dart';
import 'package:medicine_reminder/screens/profile_screen.dart';
import 'package:medicine_reminder/widgets/custom_bottom_sheet.dart';
import 'package:medicine_reminder/widgets/info_container_list.dart';
import 'package:medicine_reminder/widgets/pill_container.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  ScrollController controller = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addPill(PillModel pill) {
    final updatedPills = List<PillModel>.from(widget.pills)..add(pill);
    widget.onPillsUpdated(updatedPills);
  }

  void _deletePill(BuildContext context, PillModel pill) {
    final updatedPills = List<PillModel>.from(widget.pills)..remove(pill);
    widget.onPillsUpdated(updatedPills);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pill.name} deleted'),
        backgroundColor: const Color(0xff6A9C89),
      ),
    );
  }

  void _markAsTaken(PillModel pill) {
    setState(() {
      pill.isTaken = true;
    });
    widget.onPillsUpdated(widget.pills);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pill.name} marked as taken'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notTakenPills = widget.pills.where((pill) => !pill.isTaken).toList();
    final takenPills = widget.pills.where((pill) => pill.isTaken).toList();

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
                heightFactor: 0.95,
                child: CustomBottomSheet(
                  onAddPill: _addPill,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "How is your \nhealth today?",
                    style: TextStyle(fontSize: 42.sp, fontFamily: 'prompt'),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(18.r),
                      decoration: const BoxDecoration(
                          color: Color(0xffC4DAD2), shape: BoxShape.circle),
                      child: Text(
                        "P",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: 'prompt',
                          color: const Color(0xff16423C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            const InfoContainerList(),
            SizedBox(height: 15.h),
            // Padding(
            //   padding: EdgeInsets.only(left: 18.0.w),
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: Text(
            //       "To take",
            //       style: TextStyle(
            //         fontSize: 28.sp,
            //         fontWeight: FontWeight.bold,
            //         color: const Color(0xff16423C),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: const Color(0xff16423C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicatorColor: const Color(0xff16423C),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "To Take"),
                    Tab(text: "Taken"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  //not taken pils
                  notTakenPills.isEmpty
                      ? Center(
                          child: Text(
                            "No reminders scheduled",
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.grey),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: FadingEdgeScrollView.fromScrollView(
                            gradientFractionOnStart: 0.1,
                            gradientFractionOnEnd: 0.1,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 80.h),
                              controller: controller,
                              itemCount: notTakenPills.length,
                              itemBuilder: (context, index) {
                                final pill = notTakenPills[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.0.w),
                                  child: Slidable(
                                    key: Key(pill.id.toString()),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _deletePill(context, pill);
                                          },
                                          child: _buildContainer(
                                            icon: Iconsax.trash,
                                            color: Colors.red.shade700,
                                            label: "Delete",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _markAsTaken(pill);
                                            });
                                          },
                                          child: _buildContainer(
                                            icon: Iconsax.tick_circle,
                                            color: Colors.green.shade700,
                                            label: "Taken",
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: PillContainer(pill: pill),
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
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.grey),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h),
                            itemCount: takenPills.length,
                            itemBuilder: (context, index) {
                              final pill = takenPills[index];
                              return PillContainer(pill: pill);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildContainer({
  required IconData icon,
  required Color color,
  required String label,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
