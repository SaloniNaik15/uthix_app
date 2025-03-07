import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/live_classes.dart';

import 'package:uthix_app/view/instructor_dashboard/Class/new_announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';

class InstructorClass extends StatefulWidget {
  const InstructorClass({super.key});

  @override
  State<InstructorClass> createState() => _InstructorClassState();
}

class _InstructorClassState extends State<InstructorClass> {
  List<dynamic> classData = [];
  bool isLoading = true;
  int currentIndex = 0;
  final String token = "3|SkCLy7WfUwBHDUD0B2KSBi6JiGmji7aqbQDhr7Oa0f78c8bf";

  @override
  void initState() {
    super.initState();
    fetchClassData();
  }

  Future<void> fetchClassData() async {
    try {
      print("Fetching class data..."); // Debugging

      var response = await Dio().get(
        'https://admin.uthix.com/api/subject-classes/1',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      print("Response received: ${response.data}"); // Debugging

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
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(43, 93, 116, 1),
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
                    child: Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveClasses()));
                    },
                    child: Container(
                      width: 70,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color.fromRGBO(217, 217, 217, 1),
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
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 10,),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : classData.isEmpty
                    ? const Center(child: Text("No classes available"))
                    : Column(
                        children: [
                          const SizedBox(height: 40),
                          ClassCard(
                            subject: classData[currentIndex]["classroom"]
                                    ?["subject"]?["name"] ??
                                "Unknown",
                            mentor: classData[currentIndex]["classroom"]
                                    ?["instructor"]?["name"] ??
                                "No Mentor",
                            schedule:
                                "10:00 AM - 12:30 PM | MON THU FRI", // Hardcoded
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

            // Padding(
            //   padding: const EdgeInsets.all(40),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             Column(
            //               children: [
            //                 Text(
            //                   "Teacher",
            //                   style: GoogleFonts.urbanist(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w500,
            //                     color: const Color.fromRGBO(0, 0, 0, 1),
            //                   ),
            //                 ),
            //                 Container(
            //                   width: 45,
            //                   height: 45,
            //                   decoration: BoxDecoration(
            //                     shape: BoxShape.circle,
            //                   ),
            //                   child: ClipOval(
            //                     child: Image.asset(
            //                       "assets/login/profile.jpeg",
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //                 Text(
            //                   "Mahima",
            //                   style: GoogleFonts.urbanist(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w300,
            //                     color: const Color.fromRGBO(96, 95, 95, 1),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             const Spacer(),
            //             Column(
            //               children: [
            //                 Text(
            //                   "Participants",
            //                   style: GoogleFonts.urbanist(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w500,
            //                     color: const Color.fromRGBO(0, 0, 0, 1),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 40,
            //                   width: 80,
            //                   child: Stack(
            //                     clipBehavior: Clip.none,
            //                     children: List.generate(4, (index) {
            //                       return Positioned(
            //                         right: 15 * index.toDouble(),
            //                         child: Container(
            //                           width: 39,
            //                           height: 39,
            //                           decoration: BoxDecoration(
            //                             shape: BoxShape.circle,
            //                             color: Colors.black,
            //                           ),
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(1.0),
            //                             child: ClipOval(
            //                               child: Image.asset(
            //                                 "assets/login/profile.jpeg",
            //                                 fit: BoxFit.cover,
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       );
            //                     }),
            //                   ),
            //                 ),
            //                 Text(
            //                   "30 +",
            //                   style: GoogleFonts.urbanist(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.w300,
            //                     color: const Color.fromRGBO(96, 95, 95, 1),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 30),
            //         GestureDetector(
            //           onTap: () async {
            //             final result = await Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const NewAnnouncement()),
            //             );
            //
            //             if (result != null) {
            //               setState(
            //                   () {});
            //             }
            //           },
            //           child: Container(
            //             height: 75,
            //             width: 340,
            //             decoration: BoxDecoration(
            //               color: Color.fromRGBO(246, 246, 246, 1),
            //               borderRadius: BorderRadius.circular(7),
            //               border: Border.all(
            //                   color: Color.fromRGBO(217, 217, 217, 1), width: 1),
            //             ),
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Row(
            //                 children: [
            //                   Container(
            //                     width: 45,
            //                     height: 45,
            //                     decoration: BoxDecoration(
            //                       shape: BoxShape.circle,
            //                     ),
            //                     child: ClipOval(
            //                       child: Image.asset(
            //                         "assets/login/profile.jpeg",
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                   ),
            //                   const SizedBox(width: 10),
            //                   Text(
            //                     "Announce something to your class",
            //                     style: GoogleFonts.urbanist(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w400,
            //                       color: const Color.fromRGBO(142, 140, 140, 1),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         SizedBox(
            //           height: 500,
            //           child: ListView.builder(
            //             itemCount: 5,
            //             itemBuilder: (context, index) {
            //               return Stack(
            //                 clipBehavior: Clip.none,
            //                 children: [
            //                   Padding(
            //                     padding:
            //                         const EdgeInsets.only(top: 10, bottom: 30),
            //                     child: Container(
            //                       width: 340,
            //                       decoration: BoxDecoration(
            //                         color: Color.fromRGBO(246, 246, 246, 1),
            //                         borderRadius: BorderRadius.circular(7),
            //                         border: Border.all(
            //                             color: Color.fromRGBO(217, 217, 217, 1),
            //                             width: 1),
            //                       ),
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           mainAxisSize: MainAxisSize.min,
            //                           children: [
            //                             Row(
            //                               children: [
            //                                 Container(
            //                                   width: 45,
            //                                   height: 45,
            //                                   decoration: BoxDecoration(
            //                                     shape: BoxShape.circle,
            //                                   ),
            //                                   child: ClipOval(
            //                                     child: Image.asset(
            //                                       "assets/login/profile.jpeg",
            //                                       fit: BoxFit.cover,
            //                                     ),
            //                                   ),
            //                                 ),
            //                                 const SizedBox(
            //                                   width: 10,
            //                                 ),
            //                                 Column(
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   children: [
            //                                     Text(
            //                                       "Surayaiya Jagannath",
            //                                       style: GoogleFonts.urbanist(
            //                                         fontSize: 14,
            //                                         fontWeight: FontWeight.w500,
            //                                         color: const Color.fromRGBO(
            //                                             0, 0, 0, 1),
            //                                       ),
            //                                     ),
            //                                     Text(
            //                                       "10:20 AM    12 AUG 2025",
            //                                       style: GoogleFonts.urbanist(
            //                                         fontSize: 10,
            //                                         fontWeight: FontWeight.w500,
            //                                         color: const Color.fromRGBO(
            //                                             96, 95, 95, 1),
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                                 const Spacer(),
            //                                 Icon(Icons.more_vert)
            //                               ],
            //                             ),
            //                             const SizedBox(
            //                               height: 10,
            //                             ),
            //                             //if attachements,files,comments,questions
            //                             Text(
            //                               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ",
            //                               style: GoogleFonts.urbanist(
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w400,
            //                                 color:
            //                                     const Color.fromRGBO(0, 0, 0, 1),
            //                               ),
            //                             ),
            //                             const SizedBox(
            //                               height: 10,
            //                             ),
            //                             Text(
            //                               "Add Attachemnet",
            //                               style: GoogleFonts.urbanist(
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w500,
            //                                 color: const Color.fromRGBO(
            //                                     142, 140, 140, 1),
            //                               ),
            //                             ),
            //                             Container(
            //                               height: 1,
            //                               color: Color.fromRGBO(213, 213, 213, 1),
            //                             ),
            //                             const SizedBox(
            //                               height: 8,
            //                             ),
            //                             Text(
            //                               "Add Comment",
            //                               style: GoogleFonts.urbanist(
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w500,
            //                                 color: const Color.fromRGBO(
            //                                     142, 140, 140, 1),
            //                               ),
            //                             ),
            //                             const SizedBox(
            //                               height: 8,
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Positioned(
            //                     left: 20,
            //                     bottom: 20,
            //                     child: Container(
            //                       width: 35,
            //                       height: 22,
            //                       decoration: BoxDecoration(
            //                         color: Color.fromRGBO(246, 246, 246, 1),
            //                         borderRadius: BorderRadius.circular(9),
            //                         border: Border.all(
            //                             color: Color.fromRGBO(217, 217, 217, 1),
            //                             width: 1),
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceEvenly,
            //                         children: [
            //                           Image.asset(
            //                               "assets/instructor/emoticon-happy-outline.png"),
            //                           Icon(
            //                             Icons.add,
            //                             size: 10,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               );
            //             },
            //           ),
            //         ),
            //
            //
            //         SizedBox(
            //           height: 350,
            //           child: ListView.builder(
            //             itemCount: announcementProvider.announcements.length,
            //             itemBuilder: (context, index) {
            //               return GestureDetector(
            //                 onTap: () {
            //                   if (announcementProvider.announcements[index]
            //                       .contains("Submit your report")) {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => Submission()),
            //                     );
            //                   }
            //                 },
            //                 child: Container(
            //                   width: 340,
            //                   margin: const EdgeInsets.symmetric(
            //                       vertical: 8, horizontal: 10),
            //                   decoration: BoxDecoration(
            //                     color: const Color.fromRGBO(246, 246, 246, 1),
            //                     borderRadius: BorderRadius.circular(7),
            //                     border: Border.all(
            //                       color: const Color.fromRGBO(217, 217, 217, 1),
            //                       width: 1,
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             ClipOval(
            //                               child: Image.asset(
            //                                 "assets/login/profile.jpeg",
            //                                 width: 45,
            //                                 height: 45,
            //                                 fit: BoxFit.cover,
            //                               ),
            //                             ),
            //                             const SizedBox(width: 10),
            //                             Text(
            //                               "Surayaiya Jagannath",
            //                               style: GoogleFonts.urbanist(
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w500,
            //                                 color: Colors.black,
            //                               ),
            //                             ),
            //                             const Spacer(),
            //                             const Icon(Icons.more_vert),
            //                           ],
            //                         ),
            //                         const SizedBox(height: 8),
            //                         Text(
            //                           announcementProvider.announcements[index],
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 16,
            //                             fontWeight: FontWeight.w500,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 10),
            //                         Text(
            //                           "Add Attachment",
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w500,
            //                             color: const Color.fromRGBO(
            //                                 142, 140, 140, 1),
            //                           ),
            //                         ),
            //                         Container(
            //                           height: 1,
            //                           color:
            //                               const Color.fromRGBO(213, 213, 213, 1),
            //                           margin:
            //                               const EdgeInsets.symmetric(vertical: 8),
            //                         ),
            //                         Text(
            //                           "Add Comment",
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w500,
            //                             color: const Color.fromRGBO(
            //                                 142, 140, 140, 1),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //
            //         SizedBox(
            //           height: 350,
            //           child: ListView.builder(
            //             itemCount: announcementProvider.announcements.length,
            //             itemBuilder: (context, index) {
            //               return GestureDetector(
            //                 onTap: () {
            //                   if (announcementProvider.announcements[index]
            //                       .contains("Submit your report")) {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => Submission()),
            //                     );
            //                   }
            //                 },
            //                 child: Container(
            //                   width: 340,
            //                   margin: const EdgeInsets.symmetric(
            //                       vertical: 8, horizontal: 10),
            //                   decoration: BoxDecoration(
            //                     color: const Color.fromRGBO(246, 246, 246, 1),
            //                     borderRadius: BorderRadius.circular(7),
            //                     border: Border.all(
            //                       color: const Color.fromRGBO(217, 217, 217, 1),
            //                       width: 1,
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             ClipOval(
            //                               child: Image.asset(
            //                                 "assets/login/profile.jpeg",
            //                                 width: 45,
            //                                 height: 45,
            //                                 fit: BoxFit.cover,
            //                               ),
            //                             ),
            //                             const SizedBox(width: 10),
            //                             Text(
            //                               "Surayaiya Jagannath",
            //                               style: GoogleFonts.urbanist(
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w500,
            //                                 color: Colors.black,
            //                               ),
            //                             ),
            //                             const Spacer(),
            //                             const Icon(Icons.more_vert),
            //                           ],
            //                         ),
            //                         const SizedBox(height: 8),
            //                         Text(
            //                           announcementProvider.announcements[index],
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 16,
            //                             fontWeight: FontWeight.w500,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 10),
            //                         Text(
            //                           "Add Attachment",
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w500,
            //                             color: const Color.fromRGBO(
            //                                 142, 140, 140, 1),
            //                           ),
            //                         ),
            //                         Container(
            //                           height: 1,
            //                           color:
            //                               const Color.fromRGBO(213, 213, 213, 1),
            //                           margin:
            //                               const EdgeInsets.symmetric(vertical: 8),
            //                         ),
            //                         Text(
            //                           "Add Comment",
            //                           style: GoogleFonts.urbanist(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w500,
            //                             color: const Color.fromRGBO(
            //                                 142, 140, 140, 1),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
