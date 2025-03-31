import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening attachment URLs

import '../submission/view_assignmnets.dart';
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

  // Unique cache key based on the chapter id.
  String get cacheKey => "chapter_${widget.classId}_data";

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
        // The cached data is expected to be the entire chapter object.
        final Map<String, dynamic> chapter = jsonDecode(cachedData);
        setState(() {
          classData = [
            {
              "classroom": {
                "subject": {"name": chapter["title"]},
                "instructor": {
                  "name": chapter["instructor_name"] ?? "No Mentor"
                },
              },
              "title": chapter["description"],
            }
          ];
          announcementsData = chapter["announcements"] ?? [];
        });
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

    final String url =
        "https://admin.uthix.com/api/chapter/${widget.classId}/announcements";

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
        // Extract the chapter details from the response.
        final Map<String, dynamic> chapter = response.data["chapter_title"];
        final List announcements = chapter["announcements"] ?? [];
        final instructorName = response.data["instructor_name"] ?? "No Mentor";

        setState(() {
          classData = [
            {
              "classroom": {
                "subject": {"name": chapter["title"]},
                "instructor": {"name": instructorName},
              },
              "title": chapter["description"],
            }
          ];
          announcementsData = announcements;
        });

        // Update the cache with the new chapter data.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(cacheKey, jsonEncode(chapter));
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

  /// Opens the attachment URL using url_launcher.
  Future<void> _openAttachment(String attachmentUrl) async {
    final Uri url = Uri.parse(attachmentUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch $attachmentUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract current class data (if available)
    final currentClass = classData.isNotEmpty ? classData[currentIndex] : null;
    final subjectName =
        currentClass?["classroom"]?["subject"]?["name"] ?? "Unknown";
    final mentorName =
        currentClass?["classroom"]?["instructor"]?["name"] ?? "No Mentor";
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
                    fontSize: 14,
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
                  SizedBox(height: 20.h),
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
            // Announcements & Teacher/Participants Section.
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // "Announce something to your class" section.
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewAnnouncement(classId: widget.classId),
                      ),
                    ),
                    child: Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width / 0.5,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
                      height: 450.h,
                      child: isAnnouncementsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : announcementsData.isEmpty
                              ? Center(
                                  child: Text(
                                    "No assignment posted yet!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: announcementsData.length,
                                  itemBuilder: (context, index) {
                                    final announcement =
                                        announcementsData[index];
                                    // Use mentorName for all announcements.
                                    final instructorName = mentorName;
                                    final titleText =
                                        announcement["title"] ?? "No Title";
                                    final attachments =
                                        announcement["attachments"]
                                            as List<dynamic>;
                                    final announcementId =
                                        announcement["id"].toString();

                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 400.h,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              246, 246, 246, 1),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                217, 217, 217, 1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  PopupMenuButton<String>(
                                                    color: Colors.white,
                                                    onSelected: (value) {
                                                      if (value ==
                                                          'view_submission') {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewAssignmnets(
                                                              announcementId:
                                                                  announcementId,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return [
                                                        PopupMenuItem<String>(
                                                          value:
                                                              'view_submission',
                                                          child: Text(
                                                              "View Submission"),
                                                        ),
                                                      ];
                                                    },
                                                    icon: const Icon(
                                                        Icons.more_vert),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              // Announcement title.
                                              Text(
                                                titleText,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              // Attachments display.
                                              // Attachments display.
                                              attachments.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        // Optional: Open the first attachment or a detailed view of attachments.
                                                        final String
                                                            attachmentUrl =
                                                            "https://admin.uthix.com/${attachments[0]["attachment_file"]}";
                                                        _openAttachment(
                                                            attachmentUrl);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 12.h),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .attach_file,
                                                                color:
                                                                    Colors.grey,
                                                                size: 14),
                                                            SizedBox(
                                                                width: 5.w),
                                                            Expanded(
                                                              child: Text(
                                                                "${attachments.length} attachment(s) available",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      "No attachments",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color
                                                            .fromRGBO(
                                                            142, 140, 140, 1),
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 92, 116, 1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color.fromRGBO(11, 159, 167, 1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 20, right: 25,bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    subject,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                 Spacer(),
                Text(
                  "Mentor : $mentor",
                  style: TextStyle(
                    fontSize: 13,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
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
                    fontSize: 14,
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
