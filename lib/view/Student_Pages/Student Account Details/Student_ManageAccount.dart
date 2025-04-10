import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../Logout.dart';
// import '../../login/start_login.dart';

class StudentManageAccount extends StatefulWidget {
  const StudentManageAccount({super.key});

  @override
  State<StudentManageAccount> createState() => _StudentManageAccountState();
}

class _StudentManageAccountState extends State<StudentManageAccount> {
  String? accessLoginToken;
  String? profileImageUrl;
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
      final response = await dio.get(
        "https://admin.uthix.com/api/student-profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final profileData = response.data["data"];
        final user = profileData["user"];
        final classroom = profileData["classroom"];

        String? imageFileName = user?["image"];
        String? imageUrl = (imageFileName != null && imageFileName.isNotEmpty)
            ? "https://admin.uthix.com/storage/images/student/${user["image"]}"
            : null;

        setState(() {
          profile = {
            "name": user?["name"] ?? "N/A",
            "phone": user?["phone"]?.toString() ?? "N/A",
            "class": classroom?["class_name"] ?? "N/A",
            "stream": profileData["stream"] ?? "N/A",
          };
          profileImageUrl = imageUrl;
        });

        log("✅ Student profile loaded: $profile");
      } else {
        log("❌ Failed to fetch profile");
      }
    } catch (e) {
      log("❌ Error fetching profile: $e");
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
              SizedBox(height: 10),
              Text(
                "Manage your Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage("assets/login/profile.png") as ImageProvider,
                onBackgroundImageError: (_, __) {
                  setState(() {
                    profileImageUrl = null;
                  });
                },
              ),
              SizedBox(height: 10.h),
              // Use the fetched profile name; if not yet available, show a placeholder.
              Text(
                profile != null ? profile!["name"] ?? "null" : "Loading...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B5C74),
                ),
              ),
              // Optionally, you can show more details from the profile if available.

              SizedBox(height: 20.h),

              // Profile fields
              // Here we use the fetched API data. For missing fields, "null" is shown.
              _buildProfileField(Icons.person, profile?["name"] ?? "Loading..."),
              _buildProfileField(Icons.phone, profile?["phone"] ?? "Loading..."),
              _buildProfileField(Icons.school, profile?["class"] ?? "Loading..."),
              _buildProfileField(Icons.menu_book_sharp, profile?["stream"] ?? "Loading..."),

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
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFCFCFC),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: 20,
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: const Color(0xFF605F5F),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          enabled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: const Color(0xFFD2D2D2),
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: const Color(0xFFD2D2D2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
