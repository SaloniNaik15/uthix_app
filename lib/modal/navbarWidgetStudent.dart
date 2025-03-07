// navbar.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student%20Account%20Details/Student_AccountPage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';
import 'package:uthix_app/view/homeRegistration/profile.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';

class NavbarStudent extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NavbarStudent({
    required this.onItemTapped,
    required this.selectedIndex,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NavbarStudentState createState() => _NavbarStudentState();
}

class _NavbarStudentState extends State<NavbarStudent> {
  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_outlined, "title": "Home", "page": HomePages()},
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": StudFiles()},
    {"icon": Icons.find_in_page, "title": "Find", "page": BuyTextBooks()},
    {"icon": Icons.chat_outlined, "title": "Chat", "page": StudChat()},
    {
      "icon": Icons.person_outline,
      "title": "Profile",
      "page": const StudentAccountPages()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 59,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          navItems.length,
          (index) => GestureDetector(
            onTap: () => widget.onItemTapped(index),
            child: Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    navItems[index]["icon"],
                    size: 20,
                    color: widget.selectedIndex == index
                        ? Colors.blue
                        : const Color.fromRGBO(96, 95, 95, 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    navItems[index]["title"],
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: widget.selectedIndex == index
                          ? Colors.blue
                          : const Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
