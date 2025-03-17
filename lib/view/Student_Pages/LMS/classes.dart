// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Classes extends StatefulWidget {
  final int classroomId;
  const Classes({super.key, required this.classroomId});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  String? accessLoginToken;
  List<dynamic> classData = [];
  List<dynamic> announcementsList = [];
  bool isLoading = true;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchData();
    await fetchAnnouncements();
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
  }

  final Dio dio = Dio(); // Initialize Dio instance

  Future<void> fetchData() async {
    const String url = 'https://admin.uthix.com/api/subject-classes/1';
    String? token = accessLoginToken;

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response Code: ${response.statusCode}');
      log('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        setState(() {
          classData = responseData["data"];
          isLoading = false;
        });
      } else {
        print("Error: Invalid response structure");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching class data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAnnouncements() async {
    const String url = 'https://admin.uthix.com/api/classroom/1/announcements';
    String? token = accessLoginToken;

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response Code: ${response.statusCode}');
      log('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData["status"] == true) {
          List<dynamic> announcements = responseData["data"];

          if (mounted) {
            setState(() {
              announcementsList = announcements;
              isLoading = false;
            });
          }
        } else {
          print("Error: Invalid response structure");
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        print("Error: API request failed");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching announcements: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showPreviousClass() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  // Navigate to the next class
  void showNextClass() {
    if (currentIndex < classData.length - 1) {
      setState(() {
        currentIndex++;
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
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 25),
          onPressed: () {
            // Add menu functionality here
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/login/profile.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : classData.isEmpty
                  ? const Center(child: Text("No classes available"))
                  : Column(
                      children: [
                        const SizedBox(height: 40),
                        ClassCard(
                          subject: classData[currentIndex]["classroom"]
                                  ["subject"]["name"] ??
                              "Unknown",
                          mentor: classData[currentIndex]["classroom"]
                                  ["instructor"]["bio"] ??
                              "No Mentor",
                          schedule:
                              "${classData[currentIndex]["time"]} | ${classData[currentIndex]["repeat_days"]}",
                          coMentors: "N/A",
                          chapter: classData[currentIndex]["title"] ??
                              "No description",
                          onPrevious: showPreviousClass,
                          onNext: showNextClass,
                          hasPrevious: currentIndex > 0,
                          hasNext: currentIndex < classData.length - 1,
                        ),
                      ],
                    ),

          Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Teacher",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/login/profile.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Mahima",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            "Participants",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 80,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: List.generate(4, (index) {
                                return Positioned(
                                  right: 15 * index.toDouble(),
                                  child: Container(
                                    width: 39,
                                    height: 39,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/login/profile.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Text(
                            "30 +",
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //First post.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: announcementsList.length,
                itemBuilder: (context, index) {
                  final announcement = announcementsList[index];

                  return CommentCard(
                    profileImage: "assets/login/profile.jpeg",
                    //name: announcement["classroom"]["instructor"]["user"]["name"],
                    name: "instructor",
                    timestamp: announcement["created_at"],
                    comment: announcement["title"],
                  );
                },
              ),
            ),
          ),
        ],
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
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool hasPrevious;
  final bool hasNext;

  const ClassCard({
    super.key,
    required this.subject,
    required this.mentor,
    required this.schedule,
    required this.coMentors,
    required this.chapter,
    required this.onPrevious,
    required this.onNext,
    required this.hasPrevious,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
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
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  "Mentor : $mentor",
                  style: GoogleFonts.urbanist(
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
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  "$coMentors Co-Mentors",
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 10, color: Colors.white),
                      onPressed: hasPrevious
                          ? onPrevious
                          : null, // Disable if no previous class
                    ),
                    // const SizedBox(width: 2),
                    _buildTabText("PREVIOUS"),
                    const SizedBox(width: 25),
                    _buildTabText("ONGOING"),
                    const SizedBox(width: 25),
                    _buildTabText("NEXT"),
                    const SizedBox(width: 2),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 10, color: Colors.white),
                      onPressed:
                          hasNext ? onNext : null, // Disable if no next class
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  width: 300,
                  color: const Color.fromRGBO(11, 159, 167, 1),
                ),
                const SizedBox(height: 10),
                Text(
                  "CHAPTER: $chapter",
                  style: GoogleFonts.urbanist(
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

  Widget _buildTabText(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String timestamp;
  final String comment;

  const CommentCard({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.timestamp,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          child: Container(
            width: 340,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            profileImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
                      const Icon(Icons.more_vert),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    comment,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: const Color.fromRGBO(213, 213, 213, 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add Comment",
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(142, 140, 140, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: Container(
            width: 35,
            height: 22,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: const Color.fromRGBO(217, 217, 217, 1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/instructor/emoticon-happy-outline.png"),
                const Icon(Icons.add, size: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
