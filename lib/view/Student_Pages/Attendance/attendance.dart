import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  double percentage = 77; // Update this value dynamically as needed

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
                size: 25.sp, color: Colors.white),
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
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              "Total 9 classes attended out of 12",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
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
              "Mahima Mandal",
              style: GoogleFonts.urbanist(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(43, 92, 116, 1),
              ),
            ),
            Text(
              "Class X B",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
            Text(
              "Delhi Public School, New Delhi",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
            Text(
              "+91 XXXXX XXXXX",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
             SizedBox(height: 50.h),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 203,
                    height: 203,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10.w,
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
                      strokeWidth: 7.w,
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
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(
              height: 25.h,
            ),
            Text(
              "Need $percentage% to pass",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
             SizedBox(height: 90.h),
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
      height: 102.h,
      width: 102.w,
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
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
        ],
      ),
    );
  }
}
