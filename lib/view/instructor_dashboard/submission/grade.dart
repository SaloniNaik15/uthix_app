// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Grade extends StatefulWidget {
  const Grade({super.key});

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  // A map to track the selected rating for each criterion.
  // The key is the criterion and the value is the selected rating.
  final Map<String, String> selectedGrades = {};

  Widget gradeRow(String criteria, List<String> ratings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 39,
          width: 86,
          alignment: Alignment.centerLeft,
          child: Text(
            criteria,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        for (var rating in ratings)
          GestureDetector(
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
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 1),
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
    TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Grading and Feedback",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Please grade the work according to the following criterion",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
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
              const Divider(
                thickness: 2,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.menu,
                        color: Color.fromRGBO(96, 95, 95, 1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: feedbackController,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(96, 95, 95, 1),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Feedback Note",
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  height: 42,
                  width: 170,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(43, 92, 116, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(255, 255, 255, 1),
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
