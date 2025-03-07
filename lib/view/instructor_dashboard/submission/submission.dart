// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/view_assignmnets.dart';

class Submission extends StatefulWidget {
  const Submission({super.key});

  @override
  State<Submission> createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  List<bool> replyVisible = List.generate(13, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Container(
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
          ),
          const SizedBox(
            height: 40,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 246, 246, 1),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: Color.fromRGBO(217, 217, 217, 1), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Date",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Due: 20 Jan 2025",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Submit your Report here ",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(96, 95, 95, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "6 Class Comments",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(142, 140, 140, 1),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "11 out of 30 Submissions",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(142, 140, 140, 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAssignmnets()));
                        },
                        child: Container(
                          height: 27,
                          width: 148,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color.fromRGBO(43, 92, 116, 1),
                          ),
                          child: Center(
                            child: Text(
                              "View Submission",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: -8,
                child: Container(
                  width: 35,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                        color: Color.fromRGBO(217, 217, 217, 1), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                          "assets/instructor/emoticon-happy-outline.png"),
                      Icon(Icons.add, size: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Comment",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(96, 95, 95, 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                height: 500,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 13,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 39,
                                height: 39,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
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
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Name",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Date",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                96, 95, 95, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Lorem ipsum dolor sit amet.",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                    // Reply button
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          replyVisible[index] =
                                              !replyVisible[index];
                                        });
                                      },
                                      child: Text(
                                        "Reply",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(
                                              96, 95, 95, 1),
                                        ),
                                      ),
                                    ),
                                    // Using if-else to handle visibility of reply
                                    replyVisible[index]
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 40), // Indent the reply
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 39,
                                                      height: 39,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: ClipOval(
                                                          child: Image.asset(
                                                            "assets/login/profile.jpeg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Reply Name",
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  0, 0, 0, 1),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            "This is a reply to the comment.",
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  0, 0, 0, 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(), // Empty container if not visible
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
