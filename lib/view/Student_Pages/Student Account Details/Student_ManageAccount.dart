import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../Logout.dart';
import '../../login/start_login.dart';

class StudentManageAccount extends StatefulWidget {
  const StudentManageAccount({super.key});

  @override
  State<StudentManageAccount> createState() => _StudentManageAccountState();
}

class _StudentManageAccountState extends State<StudentManageAccount> {
  String? accessLoginToken;
  // Holds the fetched profile data
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await _fetchProfile();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
  }

  Future<void> _fetchProfile() async {
    try {
      final dio = Dio();
      // Replace with your actual API endpoint.
      final response = await dio.get(
        "https://admin.uthix.com/api/profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          profile = response.data;
        });
        log("Profile fetched: ${response.data}");
      } else {
        log("Failed to fetch profile: ${response.statusMessage}");
        setState(() {
          profile = null;
        });
      }
    } catch (e) {
      log("Error fetching profile: $e");
      setState(() {
        profile = null;
      });
    }
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
              // Use the fetched profile name; if not yet available, show a placeholder.
              Text(
                profile != null ? profile!["name"] ?? "null" : "Loading...",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B5C74),
                ),
              ),
              // Optionally, you can show more details from the profile if available.
              Text(
                profile != null
                    ? "Class X B\nDelhi Public School, New Delhi\n+91 ${profile!["phone"] ?? "null"}"
                    : "Loading...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),

              // Profile fields
              // Here we use the fetched API data. For missing fields, "null" is shown.
              _buildProfileField(
                  Icons.person, profile != null ? profile!["name"] ?? "null" : "Loading..."),
              _buildProfileField(
                  Icons.phone, profile != null ? profile!["phone"]?.toString() ?? "null" : "Loading..."),
              // The sample API does not provide location or school. So we display "null".
              _buildProfileField(Icons.location_on, "null"),
              _buildProfileField(Icons.school, "null"),

              SizedBox(height: 30.h),

              // Logout Button with Popup
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: MediaQuery.sizeOf(context).width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      logoutUser(context);
                    },
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
