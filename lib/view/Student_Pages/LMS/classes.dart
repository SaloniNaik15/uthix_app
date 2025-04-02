import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uthix_app/view/Student_Pages/LMS/submission_student.dart';
import 'package:uthix_app/view/Student_Pages/LMS/live_student.dart';

class Classes extends StatefulWidget {
  final int chapterId;
  const Classes({Key? key, required this.chapterId}) : super(key: key);

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  String? token;
  bool isLoading = true;

  // Map to hold class/chapter details (derived from API's "chapter_title")
  // We add "chapter_id" to pass later.
  Map<String, String> classInfo = {
    "subject": "",
    "time": "",
    "days": "",
    "mentor": "",
    "chapter": "",
    "chapter_id": "",
  };

  // List to hold announcements; each announcement is a Map with keys:
  // name, timestamp, comment, attachments (list), profile, announcement_id.
  List<Map<String, dynamic>> announcementsList = [];
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchData();
  }

  Future<void> _loadTokenAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');

    if (token != null) {
      await fetchData();
    } else {
      log("Token not found!");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    final String url =
        "https://admin.uthix.com/api/student/chapters/${widget.chapterId}/announcements";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("Response Data: ${response.data}");

      if (response.data['status'] == true) {
        final chapter = response.data['chapter_title'];
        setState(() {
          classInfo = {
            "subject": chapter["title"] ?? "Unknown",
            "time": chapter["time"] != null && chapter["timezone"] != null
                ? "${chapter["time"]} ${chapter["timezone"]}"
                : (chapter["time"] ?? ""),
            "days": chapter["repeat_days"] ?? "",
            "mentor": (response.data["announcements"] as List).isNotEmpty
                ? (response.data["announcements"][0]["instructor_name"] ??
                "No Mentor")
                : "No Mentor",
            "chapter": chapter["description"] ?? "",
            "chapter_id": chapter["id"]?.toString() ?? "",
          };

          // Map each announcement including announcement_id.
          announcementsList = (response.data["announcements"] as List)
              .map((item) => {
            "name": item["instructor_name"] ?? "",
            "timestamp": item["created_at"] ?? "",
            "comment": item["title"] ?? "",
            "attachments": item["attachments"] ?? [],
            "profile": item["instructor"]?["user"]?["image"] ?? "",
            "announcement_id": item["announcement_id"]?.toString() ?? "",
          })
              .cast<Map<String, dynamic>>()
              .toList();

          isLoading = false;
        });
      } else {
        log("API returned status false");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BLUE CONTAINER for class/chapter info.
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(43, 92, 116, 1),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 16),
              child: Column(
                children: [
                  // Row with subject/time/days on the left and mentor info on the right.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classInfo["subject"] ?? "",
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${classInfo["time"]}  MON THRU FRI",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mentor info.
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Mentor : ${classInfo["mentor"]}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row with Join Class button.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveStudent(),
                            ),
                          );
                        },
                        child: Text(
                          "Join Class",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Teal divider.
                  Container(
                    height: 1,
                    color: const Color.fromRGBO(11, 159, 167, 1),
                  ),
                  const SizedBox(height: 10),
                  // Chapter Label.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHAPTER: ${classInfo["chapter"]}",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Announcements List.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: announcementsList.isEmpty
                  ? Center(
                child: Text(
                  "No assignment for this chapter yet",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )
                  : Column(
                children: announcementsList.map((announcement) {
                  return _AnnouncementCard(
                    name: announcement["name"] ?? "",
                    timestamp: announcement["timestamp"] ?? "",
                    comment: announcement["comment"] ?? "",
                    attachments:
                    announcement["attachments"] ?? [],
                    profile: announcement["profile"] ?? "",
                    announcementId:
                    announcement["announcement_id"] ?? "",
                    chapterId: classInfo["chapter_id"] ?? "",
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String name;
  final String timestamp;
  final String comment;
  final List attachments;
  final String profile;
  final String announcementId;
  final String chapterId;

  const _AnnouncementCard({
    Key? key,
    required this.name,
    required this.timestamp,
    required this.comment,
    required this.attachments,
    required this.profile,
    required this.announcementId,
    required this.chapterId,
  }) : super(key: key);

  Future<void> _openAttachment(String attachmentPath) async {
    final String url = "https://admin.uthix.com/$attachmentPath";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Spacing between cards.
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(246, 246, 246, 1),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: const Color.fromRGBO(217, 217, 217, 1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with profile image, instructor name, timestamp, and menu.
              Row(
                children: [
                  // Show profile image if available; else display first letter.
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: profile.isNotEmpty
                          ? Image.network(
                        "https://admin.uthix.com/uploads/$profile",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildInitialAvatar(name);
                        },
                      )
                          : _buildInitialAvatar(name),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Instructor name and timestamp.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(96, 95, 95, 1),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // PopupMenuButton with "Submit Assignment".
                  PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == "submit_assignment") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmissionStudent(
                              announcementId: announcementId,
                              chapterId: chapterId,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: "submit_assignment",
                          child: Text(
                            "Submit Assignment",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ];
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Announcement title text.
              Text(
                comment,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Attachment row.
              attachments.isNotEmpty
                  ? GestureDetector(
                onTap: () => _openAttachment(
                    attachments[0]["attachment_file"]),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file,
                        size: 14, color: Colors.blue),
                    const SizedBox(width: 5),
                    Text(
                      "Open Attachment",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              )
                  : Text(
                "No Attachment",
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade400,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "",
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
