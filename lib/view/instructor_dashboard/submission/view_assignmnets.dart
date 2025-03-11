import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/instructor_dashboard/submission/grade.dart';

class ViewAssignmnets extends StatefulWidget {
  const ViewAssignmnets({super.key});

  @override
  State<ViewAssignmnets> createState() => _ViewAssignmnetsState();
}

class _ViewAssignmnetsState extends State<ViewAssignmnets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
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
                const SizedBox(width: 60),
                Column(
                  children: [
                    Text(
                      "All Submissions",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    Text(
                      "Total 11 out of 30",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      height: 203,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 246, 246, 1),
                        border: Border.all(
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding: const EdgeInsets.all(1.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/login/profile.jpeg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                    Text(
                                      "Date",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color:
                                            const Color.fromRGBO(96, 95, 95, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Grade()));
                                  },
                                  child: Container(
                                    height: 37,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color.fromRGBO(43, 92, 116, 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Grade",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Name: Mahima",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            Text(
                              "Class:X B",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            Text(
                              "Please find the attached file and check the report ",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  width: 97,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromRGBO(217, 217, 217, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Transform.rotate(
                                        angle: 45 * 3.1415927 / 180,
                                        child: Image.asset(
                                          "assets/instructor/link.png",
                                          scale: 2,
                                          color: Color.fromRGBO(96, 95, 94, 1),
                                        ),
                                      ),
                                      Text(
                                        "abc.pdf",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: const Color.fromRGBO(
                                              96, 95, 95, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
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
    );
  }
}
