import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Grade extends StatefulWidget {
  final String uploadId;
  const Grade({Key? key, required this.uploadId}) : super(key: key);

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  // Stores the selected grade for each criterion.
  final Map<String, String> selectedGrades = {};
  // Controller for the feedback note.
  final TextEditingController feedbackController = TextEditingController();
  String? token;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadSavedGrades();
  }

  // Load the auth token from SharedPreferences.
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
  }

  // Load any previously saved grades for this upload.
  Future<void> _loadSavedGrades() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString("grades_${widget.uploadId}");
    if (savedData != null) {
      try {
        final Map<String, dynamic> data = json.decode(savedData);
        final Map<String, String> loadedGrades =
        Map<String, String>.from(data["selectedGrades"]);
        final String loadedFeedback = data["feedback_note"] as String;
        setState(() {
          selectedGrades.clear();
          selectedGrades.addAll(loadedGrades);
          feedbackController.text = loadedFeedback;
        });
      } catch (e) {
        debugPrint("Error loading saved grades: $e");
      }
    }
  }

  // Store the current grades and feedback note locally.
  Future<void> _storeGrades() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {
      "selectedGrades": selectedGrades,
      "feedback_note": feedbackController.text,
    };
    await prefs.setString("grades_${widget.uploadId}", json.encode(data));
  }

  // Submit the grades using the Dio package.
  Future<void> _submitGrades() async {
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not Authenticated")),
      );
      return;
    }

    final grades = selectedGrades.entries.map((entry) {
      return {
        "criterion": entry.key,
        "grade": entry.value,
      };
    }).toList();

    final payload = {
      "grades": grades,
      "feedback_note": feedbackController.text,
    };

    final url =
        'https://admin.uthix.com/api/instructor/grade/${widget.uploadId}';
    try {
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 201) {
        // Save the current grade data locally after a successful submission.
        await _storeGrades();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Grades submitted")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to submit grades. Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  // Widget that creates a row for a specific grading criterion.
  Widget gradeRow(String criteria, List<String> ratings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Criterion label.
        Container(
          height: 35,
          width: 76,
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
        SizedBox(width: 5),
        // Grade options.
        for (var rating in ratings)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedGrades[criteria] == rating) {
                    selectedGrades.remove(criteria);
                  } else {
                    selectedGrades[criteria] = rating;
                  }
                });
              },


              child: Container(
                height: 34,
                width: 87,
                decoration: BoxDecoration(
                  color: selectedGrades[criteria] == rating
                      ? const Color.fromRGBO(43, 92, 116, 1)
                      : const Color.fromRGBO(246, 246, 246, 1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color.fromRGBO(175, 175, 175, 1),
                  ),
                ),
                child: Center(
                  child: Text(
                    rating,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selectedGrades[criteria] == rating
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Enable scrolling in both directions using nested SingleChildScrollView widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 25.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width * 1.2,
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grading and Feedback",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Please grade the work according to the following criterion",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
                10.verticalSpace,
                gradeRow("Course Engagement", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Class Attendance", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Problem Solving", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Quick Thinking", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Course Knowledge", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Detailed Work", ["Excellent", "Well Done", "Basic"]),
                10.verticalSpace,
                gradeRow("Presentation Skills", ["Excellent", "Well Done", "Basic"]),
                30.verticalSpace,
                Divider(
                  thickness: 2.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: TextField(
                          controller: feedbackController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Feedback Note",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: GestureDetector(
                    onTap: _submitGrades,
                    child: Container(
                      height: 42.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(43, 92, 116, 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
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
}
