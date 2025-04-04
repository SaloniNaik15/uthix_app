import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/LMS/classWiseChapter.dart';

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

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });
  }

  Future<void> fetchClassroomData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final response = await dio.get(
        'https://admin.uthix.com/api/student-classroom',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessLoginToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> rawData = response.data['data'];
        rawData.sort((a, b) {
          final aCreated = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
          final bCreated = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
          return bCreated.compareTo(aCreated); // 🔁 newest first
        });
        List<Map<String, dynamic>> fetchedClasses =
        rawData.map<Map<String, dynamic>>((item) {
          final instructorUser = item['instructor']?['user'];
          final subject = item['subject'];
          final classroom = item['classroom'];

          log("Classroom object: ${classroom.toString()}");

          return {
            "dataId": item['id'],
            "classroomName": classroom != null && classroom['class_name'] != null
                ? classroom['class_name']
                : "Unknown Class",
            "instructor": instructorUser != null ? instructorUser['name'] : "N/A",
            "subject": subject != null ? subject['name'] : "N/A",
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
            padding: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.black, size: 20),
            ),
          ),
          title: Text(
            "Your Classroom",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Divider(
                thickness: 1.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                    ? const Center(child: Text("Failed to load classrooms"))
                    : classList.isEmpty
                    ? const Center(
                    child: Text("No classrooms assigned yet"))
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                  itemCount: classList.length,
                  itemBuilder: (context, index) {
                    final classData = classList[index];
                    return GestureDetector(
                      onTap: () {
                        int dataId = classData["dataId"];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Classwisechapter(dataId: dataId),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              classData["classroomName"] ??
                                  "Unknown Class",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(
                                    96, 95, 95, 1),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Subject: ${classData["subject"] ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              "Instructor: ${classData["instructor"] ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.group,
                                    size: 16.sp,
                                    color: Colors.blueGrey),
                                SizedBox(width: 4),
                                Text("1000",
                                    style: TextStyle(
                                        fontSize: 12)),
                                SizedBox(width: 12),
                                Icon(Icons.star,
                                    size: 16,
                                    color: Colors.orange),
                                SizedBox(width: 4),
                                Text("4.0",
                                    style: TextStyle(
                                        fontSize: 12)),
                                SizedBox(width: 12),
                                Icon(Icons.access_time,
                                    size: 16.sp,
                                    color: Colors.teal),
                                SizedBox(width: 4),
                                Text("45 Hours",
                                    style: TextStyle(
                                        fontSize: 12)),
                              ],
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
        ],
      ),
    );
  }
}
