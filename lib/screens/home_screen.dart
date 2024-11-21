import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();

  void _addPill(PillModel pill) {
    final updatedPills = List<PillModel>.from(widget.pills)..add(pill);
    widget.onPillsUpdated(updatedPills);
  }

  void _deletePill(BuildContext context, PillModel pill) {
    final updatedPills = List<PillModel>.from(widget.pills)..remove(pill);
    widget.onPillsUpdated(updatedPills);
  }

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
                              builder: (context) => const ProfileScreen()));
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            const InfoContainerList(),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.only(left: 18.0.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "To take",
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff16423C)),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: widget.pills.isEmpty
                  ? Center(
                      child: Text(
                        "No reminders scheduled",
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
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
                          itemCount: widget.pills.length,
                          itemBuilder: (context, index) {
                            final pill = widget.pills[index];
                            return Dismissible(
                              key: Key(pill.id.toString()),
                              onDismissed: (direction) {
                                _deletePill(context, pill);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${pill.name} deleted'),
                                    backgroundColor: const Color(0xff6A9C89),
                                  ),
                                );
                              },
                              background: Padding(
                                padding: EdgeInsets.symmetric(vertical: 25.0.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.0.w),
                                  child: const Icon(Iconsax.trash,
                                      color: Colors.white),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0.w),
                                child: PillContainer(pill: pill),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
