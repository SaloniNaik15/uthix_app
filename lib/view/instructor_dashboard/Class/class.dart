import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/live_classes.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/new_announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructorClass extends StatefulWidget {
  const InstructorClass({super.key, required String classId});

  @override
  State<InstructorClass> createState() => _InstructorClassState();
}

class _InstructorClassState extends State<InstructorClass> {
  List<dynamic> classData = [];
  List<dynamic> announcementsData = [];
  bool isLoading = true;
  bool isAnnouncementsLoading = true;
  int currentIndex = 0;
  String? token; // Token will be loaded from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      token = prefs.getString('auth_token');
    });
    if (token != null) {
      fetchClassData();
      fetchAnnouncements();
    } else {
      print("No token found. User may not be logged in.");
    }
  }

  Future<void> fetchAnnouncements() async {
    if (token == null) return;
    try {
      print("Fetching announcements...");
      var response = await Dio().get(
        'https://admin.uthix.com/api/classroom/1/announcements',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print("Announcements response: ${response.data}");
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          announcementsData = response.data["data"];
          isAnnouncementsLoading = false;
        });
      } else {
        print("Error: Invalid announcements response");
      }
    } catch (e) {
      print("Error fetching announcements: $e");
    }
  }

  Future<void> _openAttachment(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open attachment")),
      );
    }
  }

  Future<void> fetchClassData() async {
    if (token == null) return;
    try {
      print("Fetching class data...");
      var response = await Dio().get(
        'https://admin.uthix.com/api/subject-classes/5',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print("Response received: ${response.data}");
      if (response.statusCode == 200 && response.data["status"] == true) {
        setState(() {
          classData = response.data["data"];
          isLoading = false;
        });
      } else {
        print("Error: Invalid response structure");
      }
    } catch (e) {
      print("Error fetching class data: $e");
    }
  }

  // Navigate to the previous class
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
        elevation: 2,
        leading: IconButton(
          icon:  Icon(
            Icons.arrow_back_ios_outlined,
            size: 25.sp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Container(
          //   width: 35.w,
          //   height: 35.h,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: const Color.fromRGBO(43, 93, 116, 1),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.06),
          //         offset: const Offset(0, 2),
          //         blurRadius: 4,
          //       ),
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.04),
          //         offset: const Offset(0, 0),
          //         blurRadius: 6,
          //       ),
          //     ],
          //   ),
          //   child:  Icon(
          //     Icons.add,
          //     size: 35.sp,
          //     color: Colors.white,
          //   ),
          // ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LiveClasses()),
              );
            },
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : classData.isEmpty
                    ? const Center(child: Text("No classes available"))
                    : Column(
                        children: [
                          SizedBox(height: 40.h),
                          ClassCard(
                            subject: classData[currentIndex]["classroom"]
                                    ?["subject"]?["name"] ??
                                "Unknown",
                            mentor: classData[currentIndex]["classroom"]
                                    ?["instructor"]?["name"] ??
                                "No Mentor",
                            schedule: "10:00 AM - 12:30 PM | MON THU FRI",
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
              padding: const EdgeInsets.all(20),
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
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              width: 45,
                              height: 45,
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
                            Text(
                              "Mahima",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              "Participants",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                              width: 80.w,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: List.generate(4, (index) {
                                  return Positioned(
                                    right: 15 * index.toDouble(),
                                    child: Container(
                                      width: 39.w,
                                      height: 39.h,
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
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewAnnouncement()),
                        );
                        if (result != null) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 60.h,
                        width: MediaQuery.sizeOf(context).width/0.5,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: const Color.fromRGBO(217, 217, 217, 1),
                              width: 1),
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
                    SafeArea(
                      child: Container(
                        height: 500.h,
                        child: isAnnouncementsLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: announcementsData.length,
                                itemBuilder: (context, index) {
                                  var announcement = announcementsData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => Submission()),
                                      // );
                                    },
                                    child: Container(
                                      width: 400.h,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            246, 246, 246, 1),
                                        borderRadius: BorderRadius.circular(7),
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
                                                  announcement["instructor"]
                                                          ["name"] ??
                                                      "No Name",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Spacer(),
                                                const Icon(Icons.more_vert),
                                              ],
                                            ),
                                             SizedBox(height: 8.h),
                                            Text(
                                              announcement["title"] ?? "No Title",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                           SizedBox(height: 10.h),
                                            (announcement["attachments"] !=
                                                        null &&
                                                    announcement["attachments"]
                                                            .length >
                                                        0)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: List.generate(
                                                        announcement[
                                                                "attachments"]
                                                            .length, (index) {
                                                      final attachment =
                                                          announcement[
                                                                  "attachments"]
                                                              [index];
                                                      final attachmentUrl =
                                                          "https://admin.uthix.com/uploads/${attachment['attachment_file']}";
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 4.0),
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              _openAttachment(
                                                                  context,
                                                                  attachmentUrl),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons
                                                                      .attach_file,
                                                                  color: Colors
                                                                      .grey),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  attachment[
                                                                      "attachment_file"],
                                                                  style: TextStyle(
                                                                    fontSize: 12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  )
                                                : Text(
                                                    "No attachments",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color.fromRGBO(
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
      height: 170.h,
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
                      onPressed: hasPrevious ? onPrevious : null,
                    ),
                    _buildTabText("PREVIOUS"),
                    const SizedBox(width: 25),
                    _buildTabText("ONGOING"),
                    const SizedBox(width: 25),
                    _buildTabText("NEXT"),
                    const SizedBox(width: 2),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 10, color: Colors.white),
                      onPressed: hasNext ? onNext : null,
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
