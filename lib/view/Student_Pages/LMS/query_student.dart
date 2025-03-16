import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/view/Student_Pages/LMS/detail_query.dart';
import 'package:uthix_app/view/Student_Pages/LMS/query_history.dart';


class QueryStudent extends StatefulWidget {
  const QueryStudent({super.key});

  @override
  State<QueryStudent> createState() => _QueryStudentState();
}

class _QueryStudentState extends State<QueryStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 40,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryHistory()),
                );
              },
              child: Container(
                width: 120.w,
                height: 40.h,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromRGBO(43, 92, 116, 1),
                ),
                child: Center(
                  child: Text(
                    "My Queries",
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Container(
              height: 230.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(
                    color: Color.fromRGBO(11, 159, 167, 1), width: 1),
              ),
              child: Image.asset("assets/instructor/liveclasses.png",
                  fit: BoxFit.cover),
            ),
            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SUBJECT: Mathematics",
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(16, 95, 131, 1),
                  ),
                ),
                Text(
                  "CHAPTER: Algebra by Om Prakash",
                  style: GoogleFonts.urbanist(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(132, 132, 132, 1),
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 340.w,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(7.r),
                      border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/login/profile.jpeg",
                                width: 45.w,
                                height: 45.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Surayaiya Jagannath",
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.more_vert),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Submit Reports", // Dynamic query display
                          style: GoogleFonts.urbanist(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Add Attachment",
                          style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(142, 140, 140, 1),
                          ),
                        ),
                        Divider(color: Color.fromRGBO(213, 213, 213, 1)),
                        Text(
                          "Add Comment",
                          style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(142, 140, 140, 1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
