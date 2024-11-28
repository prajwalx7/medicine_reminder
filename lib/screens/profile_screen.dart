import 'package:MedTrack/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = _auth.currentUser;

    nameController.text =
        prefs.getString('name') ?? (user?.displayName ?? "Unknown");
    ageController.text = prefs.getString('age') ?? "0";
    genderController.text = prefs.getString('gender') ?? "Not Available";
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('gender', genderController.text);
  }

  Future<void> _logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: const Text("Error in Signing Out")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F4F6),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xff16423C)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff16423C),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100.r,
                width: 100.r,
                decoration: const BoxDecoration(
                  color: Color(0xffC4DAD2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.user,
                  size: 60,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              TextButton.icon(
                onPressed: () async {
                  if (isEditing) {
                    await _saveUserData();
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                icon: const Icon(Iconsax.edit,
                    color: Color(0xff16423C), size: 18),
                label: Text(
                  isEditing ? "Save Changes" : "Edit Profile",
                  style: TextStyle(
                    color: const Color(0xff16423C),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffE9EFEC),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              buildTextField("Name", nameController),
              buildTextField("Age", ageController),
              buildTextField("Gender", genderController),
              SizedBox(height: 80.h),

              // Logout
              ElevatedButton(
                onPressed: () {
                  _logOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff16423C),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'kanit',
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff16423C),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              enabled: isEditing,
              cursorColor: const Color(0xff16423C),
              style: TextStyle(fontSize: 16.sp, color: const Color(0xff16423C)),
              decoration: InputDecoration(
                hintText: "Enter your $label",
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
