import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  double percentage = 77;
  String? accessLoginToken;
  String studentName = "";
  String studentClass = "";
  String studentPhone = "";// Update this value dynamically as needed
  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }
    Future<void> _initializeProfileData() async {
      final prefs = await SharedPreferences.getInstance();
      accessLoginToken = prefs.getString('auth_token');

      try {
        final dio = Dio();
        final response = await dio.get(
          "https://admin.uthix.com/api/student-profile",
          options: Options(
            headers: {"Authorization": "Bearer $accessLoginToken"},
          ),
        );

        if (response.statusCode == 200 && response.data["status"] == true) {
          final data = response.data["data"];
          final user = data["user"];
          final classroom = data["classroom"];

          setState(() {
            studentName = user["name"] ?? "";
            studentClass = classroom?["class_name"] ?? "";
            studentPhone = user["phone"].toString();
          });

          log("✅ Attendance Profile Data Loaded");
        } else {
          log("❌ Failed to load student profile");
        }
      } catch (e) {
        log("❌ Error: $e");
      }
    }
  @override
  Widget build(BuildContext context) {
    double progressValue =
        percentage / 100; // Convert percentage to progress value (0 to 1)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
        elevation: 0,
        toolbarHeight: 90.h, // Sets the height of the AppBar
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon:  Icon(Icons.arrow_back_ios_outlined,
                size: 25, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "My Attendance",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              "Total 9 classes attended out of 12",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true, // Ensures the text is centered
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(height: 50.h),
            Text(
              studentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(43, 92, 116, 1),
              ),
            ),
            Text(
              studentClass,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
            Text(
              studentPhone,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
             SizedBox(height: 50),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 203,
                    height: 203,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 237, 235, 235),
                      ),
                    ),
                  ),
                  // Inner Circle with Dynamic Progress
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 7,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(43, 92, 116, 1),
                      ),
                    ),
                  ),
                  // Percentage Text (Dynamic)
                  Text(
                    "$percentage%",
                    style: GoogleFonts.urbanist(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(
              height: 25,
            ),
            Text(
              "Need $percentage% to pass",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
             SizedBox(height: 80.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildInfoCard("Last Grade", "70%"),
                  buildInfoCard("Assignments", "5/8"),
                  buildInfoCard("Attendance", "$percentage%"),
                ],
              ),
            ),
             SizedBox(
              height: 30.h,
            )
          ],
        ),
      ),
    );
  }

  // Helper widget for info cards
  Widget buildInfoCard(String title, String value) {
    return Container(
      height: 102,
      width: 102,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ],
      ),
    );
  }
}
