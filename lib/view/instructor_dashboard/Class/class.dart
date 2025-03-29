import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Remove or adjust these imports if they're not in your project:
import 'live_classes.dart';
import 'new_announcement.dart';

class InstructorClass extends StatefulWidget {
  final String classId;
  const InstructorClass({Key? key, required this.classId}) : super(key: key);

  @override
  State<InstructorClass> createState() => _InstructorClassState();
}

class _InstructorClassState extends State<InstructorClass> {
  final Dio _dio = Dio();
  String? token;
  List<Map<String, dynamic>> classData = [];
  List<dynamic> announcementsData = [];
  bool isLoading = false;
  bool isAnnouncementsLoading = false;
  int currentIndex = 0;

  // Unique cache key for announcements data for this chapter.
  String get cacheKey => "chapter_${widget.classId}_announcements";

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchAnnouncements();
  }

  Future<void> _loadTokenAndFetchAnnouncements() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    debugPrint("Instructor token loaded: $token");

    // Attempt to load cached data first.
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> jsonData = jsonDecode(cachedData);
        if (jsonData.isNotEmpty) {
          setState(() {
            announcementsData = jsonData;
            classData = jsonData.map((item) {
              return {
                "classroom": {
                  "subject": {"name": item['chapter']['title']},
                  "instructor": {"name": item['instructor']['name']},
                },
                "title": item['chapter']['description'],
              };
            }).toList();
          });
        }
      } catch (e) {
        log("Error decoding cached data: $e");
      }
    }

    if (token != null) {
      // Fetch fresh data from the API in background.
      await fetchAnnouncements();
    } else {
      debugPrint("Access token not found. User may not be logged in.");
      setState(() {
        isLoading = false;
        isAnnouncementsLoading = false;
      });
    }
  }

  Future<void> fetchAnnouncements() async {
    setState(() {
      isLoading = true;
      isAnnouncementsLoading = true;
    });

    final String url = "https://admin.uthix.com/api/chapter/${widget.classId}/announcements";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("Response Code: ${response.statusCode}");
      if (response.statusCode == 200 && response.data['status'] == true) {
        final List data = response.data['data'];
        if (data.isNotEmpty) {
          setState(() {
            classData = data.map((item) {
              return {
                "classroom": {
                  "subject": {"name": item['chapter']['title']},
                  "instructor": {"name": item['instructor']['name']},
                },
                "title": item['chapter']['description'],
              };
            }).toList();
            announcementsData = data;
          });
          // Update the cache with the new data.
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(cacheKey, jsonEncode(data));
        }
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
    } finally {
      setState(() {
        isLoading = false;
        isAnnouncementsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract current class data (if available)
    final currentClass = classData.isNotEmpty ? classData[currentIndex] : null;
    final subjectName = currentClass?["classroom"]?["subject"]?["name"] ?? "Unknown";
    final mentorName = currentClass?["classroom"]?["instructor"]?["name"] ?? "No Mentor";
    final chapterTitle = currentClass?["title"] ?? "No description";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 25.sp,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiveClasses()),
            ),
            child: Container(
              width: 70.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromRGBO(217, 217, 217, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Go Live",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.h),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (classData.isEmpty)
              const Center(child: Text("No classes available"))
            else
              Column(
                children: [
                  SizedBox(height: 40.h),
                  // ClassCard populated with the fetched chapter details.
                  ClassCard(
                    subject: subjectName,
                    mentor: mentorName,
                    schedule: "10:00 AM - 12:30 PM | MON THU FRI",
                    coMentors: "03",
                    chapter: chapterTitle,
                  ),
                ],
              ),
            // Announcements & Teacher/Participants Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Teacher & Participants row
                    // Row(
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Text(
                    //           "Teacher",
                    //           style: TextStyle(
                    //             fontSize: 14.sp,
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //         Container(
                    //           width: 45,
                    //           height: 45,
                    //           decoration: const BoxDecoration(
                    //             shape: BoxShape.circle,
                    //           ),
                    //           child: ClipOval(
                    //             child: Image.asset(
                    //               "assets/login/profile.jpeg",
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    //         Text(
                    //           "Mahima", // You can also replace this with dynamic teacher data if available.
                    //           style: TextStyle(
                    //             fontSize: 14.sp,
                    //             fontWeight: FontWeight.w300,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     Column(
                    //       children: [
                    //         Text(
                    //           "Participants",
                    //           style: TextStyle(
                    //             fontSize: 14.sp,
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 40.h,
                    //           width: 80.w,
                    //           child: Stack(
                    //             clipBehavior: Clip.none,
                    //             children: List.generate(4, (index) {
                    //               return Positioned(
                    //                 right: 15 * index.toDouble(),
                    //                 child: Container(
                    //                   width: 39.w,
                    //                   height: 39.h,
                    //                   decoration: BoxDecoration(
                    //                     shape: BoxShape.circle,
                    //                     color: Colors.black,
                    //                   ),
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(1.0),
                    //                     child: ClipOval(
                    //                       child: Image.asset(
                    //                         "assets/login/profile.jpeg",
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             }),
                    //           ),
                    //         ),
                    //         Text(
                    //           "30 +",
                    //           style: TextStyle(
                    //             fontSize: 10.sp,
                    //             fontWeight: FontWeight.w300,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20.h),
                    // "Announce something to your class" section
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewAnnouncement(classId: '',)),
                      ),
                      child: Container(
                        height: 60.h,
                        width: MediaQuery.sizeOf(context).width / 0.5,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: const Color.fromRGBO(217, 217, 217, 1),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 45.w,
                                height: 45.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/login/profile.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Announce something to your class",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(142, 140, 140, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Announcements list built from the fetched data.
                    SafeArea(
                      child: Container(
                        height: 500.h,
                        child: isAnnouncementsLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                          itemCount: announcementsData.length,
                          itemBuilder: (context, index) {
                            final announcement = announcementsData[index];
                            final instructorName = announcement["instructor"]?["name"] ?? "No Name";
                            final titleText = announcement["title"] ?? "No Title";
                            final attachments = announcement["attachments"] as List<dynamic>;

                            return GestureDetector(
                              onTap: () {
                                // Navigate to detailed view if required.
                              },
                              child: Container(
                                width: 400.h,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(246, 246, 246, 1),
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: const Color.fromRGBO(217, 217, 217, 1),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Instructor row.
                                      Row(
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                              "assets/login/profile.jpeg",
                                              width: 45,
                                              height: 45,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            instructorName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          // Example: If you wish to set a white background for the popup menu:
                                          PopupMenuButton<String>(
                                            color: Colors.white,
                                            onSelected: (value) {
                                              if (value == 'view_submission') {
                                                // Navigate if needed.
                                              }
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return [
                                                PopupMenuItem<String>(
                                                  value: 'view_submission',
                                                  child: Text("View Submission"),
                                                ),
                                              ];
                                            },
                                            icon: const Icon(Icons.more_vert),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      // Announcement title.
                                      Text(
                                        titleText,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      // Attachments (if any).
                                      attachments.isNotEmpty
                                          ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: attachments.map((attach) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.attach_file, color: Colors.grey),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    attach.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      )
                                          : Text(
                                        "No attachments",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(142, 140, 140, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String subject;
  final String mentor;
  final String schedule;
  final String coMentors;
  final String chapter;

  const ClassCard({
    Key? key,
    required this.subject,
    required this.mentor,
    required this.schedule,
    required this.coMentors,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 92, 116, 1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color.fromRGBO(11, 159, 167, 1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  "Mentor : $mentor",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  schedule,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color.fromRGBO(11, 159, 167, 1),
                ),
                const SizedBox(height: 10),
                Text(
                  "Description: $chapter",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
