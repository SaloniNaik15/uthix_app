// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class GradeStudent extends StatefulWidget {
  final int announcementId; // ✅ Add this line

  const GradeStudent({super.key, required this.announcementId}); // ✅ Now it works

  @override
  State<GradeStudent> createState() => _GradeStudentState();
}

class _GradeStudentState extends State<GradeStudent> {
  final Dio dio = Dio();
  final Map<String, String> selectedGrades = {}; // Store selected grades
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGradeData();
  }

  Future<void> fetchGradeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        log("❌ Auth token not found");
        return;
      }

      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      final response = await dio.get(
        'https://admin.uthix.com/api/grade/${widget.announcementId}',
      );

      log("📦 API Response: ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == true) {
        var gradeData = response.data["grade"];

        setState(() {
          feedbackController.text = gradeData["feedback_note"] ?? "";

          for (var detail in gradeData["grade_details"]) {
            selectedGrades[detail["criterion"]] = detail["grade"];
          }
        });
      } else {
        log("⚠️ Failed to fetch grades");
      }
    } catch (e) {
      log("🔥 Error fetching data: $e");
    }
  }

  Widget gradeRow(String criteria, List<String> ratings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 39,
          width: 100,
          alignment: Alignment.centerLeft,
          child: Text(
            criteria,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        for (var rating in ratings)
             Container(
              height: 34,
              width: 90,
              decoration: BoxDecoration(
                color: selectedGrades[criteria] == rating
                    ? Color.fromRGBO(
                        43, 92, 116, 1) // Selected grade highlighted in green
                    : Colors.grey[200], // Unselected in light grey
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  rating,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: selectedGrades[criteria] == rating
                        ? Colors.white // ✅ white text for selected
                        : Colors.black, // default for others
                  ),
                ),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Grading and Feedback",
                style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                "Please grade the work according to the following criterion",
                style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54),
              ),
              const SizedBox(height: 40),
              gradeRow(
                  "Course Engagement", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow("Class Attendance", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow("Problem Solving", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow("Quick Thinking", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow("Course Knowledge", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow("Detailed Work", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 18),
              gradeRow(
                  "Presentation Skills", ["Excellent", "Well Done", "Basic"]),
              const SizedBox(height: 30),
              const Divider(thickness: 2, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: feedbackController,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Feedback Note",
                          hintStyle: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
