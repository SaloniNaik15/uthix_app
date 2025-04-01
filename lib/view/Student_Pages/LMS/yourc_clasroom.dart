// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/LMS/classes.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';

class YourClasroom extends StatefulWidget {
  const YourClasroom({super.key});

  @override
  State<YourClasroom> createState() => _YourClasroomState();
}

class _YourClasroomState extends State<YourClasroom> {
  int selectedIndex = 0;
  String? accessLoginToken;
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> classList = [];

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    if (accessLoginToken != null) {
      await fetchClassroomData();
    }
  }
  Future<void> fetchClassroomData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final response = await dio.get(
        'https://admin.uthix.com/api/student-classroom', // 🔁 Replace with your actual endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> rawData = response.data['data'];

        // Dummy mapping (you should replace this with actual instructor/subject/classroom data retrieval)
        List<Map<String, dynamic>> fetchedClasses = rawData.map<Map<String, dynamic>>((item) {
          return {
            "classroomId": item['classroom_id'],
            "className": "Classroom ${item['classroom_id']}", // Replace with real data if available
            "instructor": "Instructor ${item['instructor_id']}", // Replace with real instructor name if available
          };
        }).toList();

        setState(() {
          classList = fetchedClasses;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error fetching classroom data: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }
  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
  }



  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black, size: 20.sp),
              ),
            ),
            title: Text(
              "Your Classroom",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(96, 95, 95, 1),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Container(
                  height: 42.h,
                  width: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Student_Home_icons/stud_logo.png",
                      fit: BoxFit.cover,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Divider(thickness: 1.h, color: Color.fromRGBO(217, 217, 217, 1)),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : hasError
                      ? Center(child: Text("Failed to load classrooms"))
                      : classList.isEmpty
                      ? Center(child: Text("No classrooms assigned yet"))
                      : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    itemCount: classList.length,
                    itemBuilder: (context, index) {
                      final classData = classList[index];
                      return GestureDetector(
                        onTap: () {
                          int classroomId = classData["classroomId"];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Classes(classroomId: classroomId),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      classData["className"] ?? "Unknown Class",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(96, 95, 95, 1),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Teacher Name : ${classData["instructor"] ?? "N/A"}",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.group, size: 16.sp, color: Colors.blueGrey),
                                        SizedBox(width: 4.w),
                                        Text("1000", style: TextStyle(fontSize: 12.sp)),
                                        SizedBox(width: 12.w),
                                        Icon(Icons.star, size: 16.sp, color: Colors.orange),
                                        SizedBox(width: 4.w),
                                        Text("4.0", style: TextStyle(fontSize: 12.sp)),
                                        SizedBox(width: 12.w),
                                        Icon(Icons.access_time, size: 16.sp, color: Colors.teal),
                                        SizedBox(width: 4.w),
                                        Text("45 Hours", style: TextStyle(fontSize: 12.sp)),
                                      ],
                                    ),
                                  ],

                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Center(
                child: NavbarStudent(
                  onItemTapped: onItemTapped,
                  selectedIndex: selectedIndex,
                ),
              ),
            ),
          ],
        ),
    );
  }
}