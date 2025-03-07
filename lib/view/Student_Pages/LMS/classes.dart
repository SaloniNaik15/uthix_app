// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Student_Pages/LMS/live_student.dart';
import 'package:uthix_app/view/Student_Pages/LMS/submission_student.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/new_announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';

class Classes extends StatefulWidget {
  final int classroomId;
  const Classes({super.key, required this.classroomId});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  child: const Icon(Icons.menu, size: 25),
                ),
                const Spacer(),
                Container(
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
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(43, 92, 116, 1),
              borderRadius: BorderRadius.circular(7),
              border:
                  Border.all(color: Color.fromRGBO(11, 159, 167, 1), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Mathematics",
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Mentor : Om Prakash",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "10:00 AM-12:30 PM     MON   THU     FRI",
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "03 Co-Mentors ",
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "PREVIOUS ",
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "ONGOING",
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "NEXT",
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: 210,
                        color: Color.fromRGBO(11, 159, 167, 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "CHAPTER: Alegbra ",
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveStudent()));
                            },
                            child: Container(
                              width: 80,
                              height: 20,
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
                                  "Join Classes",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(96, 95, 95, 1),
                                  ),
                                ),
                              ),
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
                  const SizedBox(height: 30),
                  Container(
                    height: 75,
                    width: 340,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
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
                          const SizedBox(width: 10),
                          Text(
                            "Announce something to your class",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(142, 140, 140, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // SizedBox(
                  //   height: 300,
                  //   child: ListView.builder(
                  //     itemCount: 10,
                  //     itemBuilder: (context, index) {
                  //       return Stack(
                  //         clipBehavior: Clip.none,
                  //         children: [
                  //           Padding(
                  //             padding:
                  //                 const EdgeInsets.only(top: 10, bottom: 30),
                  //             child: Container(
                  //               width: 340,
                  //               decoration: BoxDecoration(
                  //                 color: Color.fromRGBO(246, 246, 246, 1),
                  //                 borderRadius: BorderRadius.circular(7),
                  //                 border: Border.all(
                  //                     color: Color.fromRGBO(217, 217, 217, 1),
                  //                     width: 1),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         Container(
                  //                           width: 45,
                  //                           height: 45,
                  //                           decoration: BoxDecoration(
                  //                             shape: BoxShape.circle,
                  //                           ),
                  //                           child: ClipOval(
                  //                             child: Image.asset(
                  //                               "assets/login/profile.jpeg",
                  //                               fit: BoxFit.cover,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         const SizedBox(
                  //                           width: 10,
                  //                         ),
                  //                         Column(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                               "Surayaiya Jagannath",
                  //                               style: GoogleFonts.urbanist(
                  //                                 fontSize: 14,
                  //                                 fontWeight: FontWeight.w500,
                  //                                 color: const Color.fromRGBO(
                  //                                     0, 0, 0, 1),
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               "10:20 AM    12 AUG 2025",
                  //                               style: GoogleFonts.urbanist(
                  //                                 fontSize: 10,
                  //                                 fontWeight: FontWeight.w500,
                  //                                 color: const Color.fromRGBO(
                  //                                     96, 95, 95, 1),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                         const Spacer(),
                  //                         Icon(Icons.more_vert)
                  //                       ],
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     //if attachements,files,comments,questions
                  //                     Text(
                  //                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ",
                  //                       style: GoogleFonts.urbanist(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w400,
                  //                         color:
                  //                             const Color.fromRGBO(0, 0, 0, 1),
                  //                       ),
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     Text(
                  //                       "Add Attachemnet",
                  //                       style: GoogleFonts.urbanist(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                         color: const Color.fromRGBO(
                  //                             142, 140, 140, 1),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       height: 1,
                  //                       color: Color.fromRGBO(213, 213, 213, 1),
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 8,
                  //                     ),
                  //                     Text(
                  //                       "Add Comment",
                  //                       style: GoogleFonts.urbanist(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                         color: const Color.fromRGBO(
                  //                             142, 140, 140, 1),
                  //                       ),
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 8,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Positioned(
                  //             left: 20,
                  //             bottom: 20,
                  //             child: Container(
                  //               width: 35,
                  //               height: 22,
                  //               decoration: BoxDecoration(
                  //                 color: Color.fromRGBO(246, 246, 246, 1),
                  //                 borderRadius: BorderRadius.circular(9),
                  //                 border: Border.all(
                  //                     color: Color.fromRGBO(217, 217, 217, 1),
                  //                     width: 1),
                  //               ),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   Image.asset(
                  //                       "assets/instructor/emoticon-happy-outline.png"),
                  //                   Icon(
                  //                     Icons.add,
                  //                     size: 10,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),

                  //First post.
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 30),
                                child: Container(
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(246, 246, 246, 1),
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
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
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Surayaiya Jagannath",
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                  ),
                                                ),
                                                Text(
                                                  "10:20 AM    12 AUG 2025",
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromRGBO(
                                                        96, 95, 95, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Icon(Icons.more_vert)
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //if attachements,files,comments,questions
                                        Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Container(
                                          height: 1,
                                          color:
                                              Color.fromRGBO(213, 213, 213, 1),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Add Comment",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                142, 140, 140, 1),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
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
                                    color: Color.fromRGBO(246, 246, 246, 1),
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                          "assets/instructor/emoticon-happy-outline.png"),
                                      Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //SubmissionPage(Reports).
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 30),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubmissionStudent(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(246, 246, 246, 1),
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(217, 217, 217, 1),
                                          width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
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
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Name",
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Date",
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          const Color.fromRGBO(
                                                              96, 95, 95, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Icon(Icons.more_vert)
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //if attachements,files,comments,questions
                                          Text(
                                            "New Assignment: Submit your report here ",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                213, 213, 213, 1),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "Add Comment",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                  142, 140, 140, 1),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
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
                                    color: Color.fromRGBO(246, 246, 246, 1),
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                          "assets/instructor/emoticon-happy-outline.png"),
                                      Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
