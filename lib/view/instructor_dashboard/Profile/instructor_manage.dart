import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorManage extends StatefulWidget {
  const InstructorManage({Key? key}) : super(key: key);

  @override
  State<InstructorManage> createState() => _InstructorManageState();
}

class _InstructorManageState extends State<InstructorManage> {
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
                radius: 50.r,
                backgroundImage: const AssetImage(
                    "assets/Seller_dashboard_images/ManageStoreBackground.png"),
              ),
              SizedBox(height: 10.h),
              Text(
                "Teacher",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B5C74),
                ),
              ),
              Text(
                "Class X B\nDelhi Public School, New Delhi\n+91 XXXXXX XXXXX",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
              // Profile Fields
              _buildProfileField(Icons.person, "Teacher"),
              _buildProfileField(Icons.phone, "+91 XXXXXX XXXXX"),
              _buildProfileField(Icons.location_on, "IP Extension, New Delhi"),
              _buildProfileField(Icons.school, "Banaras Hindu University"),
              SizedBox(height: 30.h),
              // Log Out Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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

  Widget _buildProfileField(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFCFCFC),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: 24.sp,
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: const Color(0xFF605F5F),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          enabled: false,
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
      ),
    );
  }
}
