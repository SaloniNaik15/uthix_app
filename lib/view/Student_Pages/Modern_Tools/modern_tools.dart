import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/LMS/yourc_clasroom.dart';
import 'package:uthix_app/view/instructor_dashboard/calender/calender.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';

class ModernTools extends StatefulWidget {
  const ModernTools({super.key});

  @override
  State<ModernTools> createState() => _ModernToolsState();
}

class _ModernToolsState extends State<ModernTools> {
  final List<Map<String, String>> dashBoard = [
    {"image": "assets/Modern_Tools/aieduc.png", "title": "AI in Education"},
    {
      "image": "assets/Modern_Tools/studentl_earning.png",
      "title": "Student-Centered Learning "
    },
    {
      "image": "assets/Modern_Tools/arvr.png",
      "title": "AR and VR in Education"
    },
    {
      "image": "assets/Student_Home_icons/Community.png",
      "title": "Tinkering & Experimentation"
    },
    {"image": "assets/Modern_Tools/tinkering.png", "title": "Digital Literacy"},
    {
      "image": "assets/Modern_Tools/potential.png",
      "title": "Transformative Potential"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Adjust height as needed
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0, // Ensures elements are properly aligned
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_outlined,
                      size: 25, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          title: Text(
            "Modern Tools",
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(96, 95, 95, 1),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset("assets/registration/splash.png",
                  fit: BoxFit.cover),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                    ),
                    itemCount: dashBoard.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          switch (dashBoard[index]["title"]) {
                            case "BUY BOOKS":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UnderConstructionScreen()),
                              );
                              break;
                            case "MY CLASSES":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YourClasroom()),
                              );
                              break;
                            case "Calender":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Calender()),
                              );
                              break;
                            case "Study Material":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Files()),
                              );
                              break;
                            case "Modern Tools":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ModernTools()),
                              );
                              break;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 106,
                                child: Image.asset(
                                  dashBoard[index]["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  dashBoard[index]["title"]!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
