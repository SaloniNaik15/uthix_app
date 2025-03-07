import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Recording extends StatefulWidget {
  const Recording({super.key});

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  @override
  @override
  Widget build(BuildContext context) {
    String selectedClass = 'Choose Class';

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 128,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(43, 92, 116, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
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
                  const SizedBox(width: 15),
                  Text(
                    "Files",
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  Spacer(),
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
                      child: Icon(
                        Icons.add,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
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
                      child: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 37,
                  width: 167,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Color.fromRGBO(175, 175, 175, 1), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          selectedClass,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(96, 95, 95, 1),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 47,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Newest",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 47,
                      width: 116,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Oldest",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 47,
                      width: 116,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: Color.fromRGBO(43, 92, 116, 1),
                      ),
                      child: Center(
                        child: Text(
                          "A-Z",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          "assets/files_icons/video.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Class Name, Topic",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            Text(
                              "61 GB, Modified by Instructor on 13/01/2025",
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
