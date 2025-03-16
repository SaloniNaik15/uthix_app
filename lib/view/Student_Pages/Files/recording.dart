import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudRecording extends StatefulWidget {
  const StudRecording({super.key});

  @override
  State<StudRecording> createState() => _StudRecordingState();
}

class _StudRecordingState extends State<StudRecording> {
  @override
  Widget build(BuildContext context) {
    String selectedClass = 'Choose Class';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 92, 116, 1),
        elevation: 0,
        title: Text(
          "Recordings",
          style: GoogleFonts.urbanist(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        leading: _iconButton(Icons.arrow_back, () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  height: 37.h,
                  width: 167.w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color.fromRGBO(175, 175, 175, 1),
                      width: 1.w,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Row(
                      children: [
                        Text(
                          selectedClass,
                          style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 20.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _sortButton("Newest"),
                      SizedBox(width: 10.w),
                      _sortButton("Oldest"),
                      SizedBox(width: 10.w),
                      _sortButton("A-Z"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Image.asset(
                          "assets/files_icons/video.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Class Name, Topic",
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "61 GB, Modified by Instructor on 13/01/2025",
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 25.sp, color: Colors.white),
      onPressed: onPressed,
    );
  }

  Widget _sortButton(String text) {
    return Container(
      height: 47.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38.r),
        color: const Color.fromRGBO(43, 92, 116, 1),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
