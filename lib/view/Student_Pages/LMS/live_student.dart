// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:uthix_app/view/Student_Pages/LMS/query_student.dart';
import 'package:uthix_app/view/instructor_dashboard/Class/announcement.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/submission.dart';

class LiveStudent extends StatefulWidget {
  const LiveStudent({super.key});

  @override
  State<LiveStudent> createState() => _LiveStudentState();
}

class _LiveStudentState extends State<LiveStudent> {
  final TextEditingController _queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
      ),
      body: Column(
        children: [
          Container(
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border:
                  Border.all(color: Color.fromRGBO(11, 159, 167, 1), width: 1),
            ),
            child: Image.asset(
              "assets/instructor/liveclasses.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SUBJECT: Mathematics",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(16, 95, 131, 1),
                  ),
                ),
                Text(
                  "CHAPTER: Alegbra  by Om Prakasah ",
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(132, 132, 132, 1),
                  ),
                ),
                Text(
                  "YOU HAVE 3 CO-MENTORS TO HELP YOU",
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(132, 132, 132, 1),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 150,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: Color.fromRGBO(217, 217, 217, 1), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                decoration: InputDecoration(
                                  hintText: "You can type your queries here!",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Divider(
                          thickness: 1,
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "Send",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(43, 92, 116, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Queries if and announcement by teacher if.
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QueryStudent()));
                        },
                        child: Container(
                          width: 340,
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
                                    const SizedBox(width: 10),
                                    Text(
                                      "Surayaiya Jagannath",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.more_vert),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Submit",
                                  //using provider text send by query,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Add Attachment",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromRGBO(142, 140, 140, 1),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: const Color.fromRGBO(213, 213, 213, 1),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                                Text(
                                  "Add Comment",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromRGBO(142, 140, 140, 1),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
