import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructorManage extends StatefulWidget {
  const InstructorManage({Key? key}) : super(key: key);

  @override
  State<InstructorManage> createState() => _InstructorManageState();
}

class _InstructorManageState extends State<InstructorManage> {
  String instructorName = 'No Name';
  String? instructorImageUrl;
  String phoneNumber = "Not Provided";
  String email = "Not Provided";
  String specialization = "Not Specified";
  String experience = "Not Specified";

  Future<void> loadProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('instructor_name') ?? 'No Name';
    final imageUrl = prefs.getString('instructor_image_url');
    final phone = prefs.getString('instructor_phone');
    final mail = prefs.getString('instructor_email');
    final spec = prefs.getString('instructor_specialization');
    final exp = prefs.getString('instructor_experience');

    setState(() {
      instructorName = name;
      instructorImageUrl = imageUrl;
      phoneNumber = phone ?? 'Not Provided';
      email = mail ?? 'Not Provided';
      specialization = spec ?? 'Not Specified';
      experience = exp ?? 'Not Specified';
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: const Color(0xFF605F5F),
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Manage your Account",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),

              // Profile Image
              CircleAvatar(
                radius: 60.r,
                backgroundImage: instructorImageUrl != null &&
                    instructorImageUrl!.isNotEmpty
                    ? NetworkImage(instructorImageUrl!)
                    : const AssetImage("assets/login/profile.jpeg")
                as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 10.h),

              Text(
                instructorName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B5C74),
                ),
              ),
              SizedBox(height: 20.h),

              // Profile Fields
              _buildProfileField(Icons.email, email),
              _buildProfileField(Icons.phone, phoneNumber),
              _buildProfileField(Icons.school, specialization),
              _buildProfileField(Icons.school, experience),

              SizedBox(height: 30.h),

              // Log Out Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement logout logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 1.w),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(IconData icon, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        controller: TextEditingController(text: value),
        enabled: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFCFCFC),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: 24.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(
              color: const Color(0xFFD2D2D2),
              width: 2.w,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(
              color: const Color(0xFFD2D2D2),
              width: 1.w,
            ),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}