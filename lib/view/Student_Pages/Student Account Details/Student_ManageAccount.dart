import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../login/start_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentManageAccount extends StatefulWidget {
  const StudentManageAccount({super.key});

  @override
  State<StudentManageAccount> createState() => _StudentManageAccountState();
}

class _StudentManageAccountState extends State<StudentManageAccount> {
  String? accessLoginToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
  }

  Future<void> logoutUser() async {
    final url = Uri.parse("https://admin.uthix.com/api/logout");

    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessLoginToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        log("Logout successful");

        // Clear shared preferences
        await prefs.clear();
        log("SharedPreferences cleared successfully");

        // Ensure widget is still mounted before navigating
        if (!context.mounted) return;

        // Navigate to StartLogin screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartLogin()),
        );
      } else {
        log("Logout failed: ${response.body}");
      }
    } catch (e) {
      log("Error logging out: $e");
    }
  }

  // Logout Confirmation Dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Logout",
            style: TextStyle(fontSize: 18.sp),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                // Clear token and logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                log("SharedPreferences cleared successfully");

                // Call the logout function to handle API logout
                logoutUser();
              },
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
            size: 20.sp,
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
              SizedBox(height: 10.h),
              // Profile Image
              CircleAvatar(
                radius: 50.r,
                backgroundImage: AssetImage(
                  "assets/Seller_dashboard_images/ManageStoreBackground.png",
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Mahima Mandal",
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

              // Profile fields
              _buildProfileField(Icons.person, "Mahima"),
              _buildProfileField(Icons.phone, "+91 XXXXXX XXXXX"),
              _buildProfileField(Icons.location_on, "IP Extension, New Delhi"),
              _buildProfileField(Icons.school, "Banaras Hindu University"),

              SizedBox(height: 30.h),

              // Logout Button with Popup
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showLogoutDialog(context); // Show confirmation popup
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                          width: 1.w,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.black, width: 1.w,),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Add Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
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
            size: 20.sp,
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
