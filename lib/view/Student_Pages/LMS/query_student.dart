import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uthix_app/view/Student_Pages/LMS/detail_query.dart';
import 'package:uthix_app/view/Student_Pages/LMS/query_history.dart';
import 'package:uthix_app/view/Student_Pages/LMS/query_provider.dart';

class QueryStudent extends StatefulWidget {
  const QueryStudent({super.key});

  @override
  State<QueryStudent> createState() => _QueryStudentState();
}

class _QueryStudentState extends State<QueryStudent> {
  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context);

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
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 25),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 180,
                ),
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QueryHistory()),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromRGBO(43, 92, 116, 1),
                    ),
                    child: Center(
                      child: Text(
                        "My Queries",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
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
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(15),
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

                const SizedBox(height: 10),
                //Queries if and announcement by teacher if.
                SizedBox(
                  height: 450,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: queryProvider.queries.length,
                    itemBuilder: (context, index) {
                      return Container(
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
                                queryProvider
                                    .queries[index], // Dynamic query display
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
                                  color: const Color.fromRGBO(142, 140, 140, 1),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: const Color.fromRGBO(213, 213, 213, 1),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              Text(
                                "Add Comment",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(142, 140, 140, 1),
                                ),
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
          ),
        ],
      ),
    );
  }
}
