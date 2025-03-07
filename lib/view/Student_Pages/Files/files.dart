// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student%20Account%20Details/Student_AccountPage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';
import 'package:uthix_app/view/instructor_dashboard/files/recording.dart';
import 'package:uthix_app/view/instructor_dashboard/files/upload.dart';

class StudFiles extends StatefulWidget {
  const StudFiles({super.key});

  @override
  State<StudFiles> createState() => _StudFilesState();
}

class _StudFilesState extends State<StudFiles> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 1;
        });
      });
    }
  }

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_outlined, "title": "Home", "page": HomePages()},
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": StudFiles()},
    {"icon": Icons.find_in_page, "title": "Find", "page": BuyTextBooks()},
    {"icon": Icons.chat_outlined, "title": "Chat", "page": StudChat()},
    {
      "icon": Icons.person_outline,
      "title": "Profile",
      "page": StudentAccountPages()
    },
  ];

  //Now list of maps used.
  final List<Map<String, String>> files = [
    {
      "assetPath": "assets/files_icons/recording_file.png",
      "title": "Recordings",
      "description": "61 GB, Modified by Instructor on 13/01/2025",
    },
    {
      "assetPath": "assets/files_icons/document_pdf.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },
    {
      "assetPath": "assets/files_icons/image.png",
      "title": "Images",
      "description": "8 GB, Modified by User on 05/01/2025",
    },
    {
      "assetPath": "assets/files_icons/video.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },
    {
      "assetPath": "assets/files_icons/document_pdf.png",
      "title": "Documents",
      "description": "15 GB, Modified by Admin on 10/02/2025",
    },
  ];

  List<String> sortOptions = ["Newest", "Oldest", "A-Z"];
  int sortopt = 0;
  @override
  Widget build(BuildContext context) {
    String selectedClass = 'Choose Class';

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
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
                          child: Icon(
                            Icons.menu,
                            size: 25,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Upload()));
                        },
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
                            child: Icon(
                              Icons.add,
                              size: 25,
                            ),
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
                    Text(
                      "The class recordings and files uploaded by you will appear here",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
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
                      children: List.generate(
                        sortOptions.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index; // Update selected index
                            });
                          },
                          child: Container(
                            height: 47,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38),
                              color: selectedIndex == index
                                  ? Color.fromRGBO(
                                      43, 92, 116, 1) // Blue when selected
                                  : Colors
                                      .transparent, // Transparent when not selected
                              border: Border.all(
                                color: Colors.grey, // Always grey border
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                sortOptions[index],
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors
                                          .grey, // White when selected, grey when not
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          if (file["title"] == "Recordings") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Recording()),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                file["assetPath"]!,
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
                                    file["title"]!,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  ),
                                  Text(
                                    file["description"]!,
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
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: NavbarStudent(
                  onItemTapped: onItemTapped, selectedIndex: selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
