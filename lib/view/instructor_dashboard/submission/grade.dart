import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Grade extends StatefulWidget {
  const Grade({Key? key}) : super(key: key);

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
          height: 35.h,
          width: 76.w,
          alignment: Alignment.centerLeft,
          child: Text(
            criteria,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
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
              height: 34.h,
              width: 87.w,
              decoration: BoxDecoration(
                color: selectedGrades[criteria] == rating
                    ? const Color.fromRGBO(43, 92, 116, 1)
                    : const Color.fromRGBO(246, 246, 246, 1),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: const Color.fromRGBO(175, 175, 175, 1),
                ),
              ),
              child: Center(
                child: Text(
                  rating,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
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
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 20.h),
              Text(
                "Grading and Feedback",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "Please grade the work according to the following criterion",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(96, 95, 95, 1),
                ),
              ),
              SizedBox(height: 20.h),
              gradeRow("Course Engagement", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Class Attendance", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Problem Solving", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Quick Thinking", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Course Knowledge", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Detailed Work", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 18.h),
              gradeRow("Presentation Skills", ["Excellent", "Well Done", "Basic"]),
              SizedBox(height: 30.h),
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
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(96, 95, 95, 1),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Feedback Note",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(96, 95, 95, 1),
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
