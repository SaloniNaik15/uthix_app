// nav_items.dart
import 'package:flutter/material.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/view/Ecommerce/e_commerce.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student%20Account%20Details/Student_AccountPage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';

final List<Map<String, dynamic>> navStudItems = [
  {"icon": Icons.home_outlined, "title": "Home", "page": HomePages()},
  {"icon": Icons.folder_open_outlined, "title": "Files", "page": StudFiles()},
  {
    "icon": Icons.find_in_page,
    "title": "Find",
    "page": UnderConstructionScreen()
  },
  {
    "icon": Icons.chat_outlined,
    "title": "Chat",
    "page": UnderConstructionScreen()
  },
  {
    "icon": Icons.person_outline,
    "title": "Profile",
    "page": const StudentAccountPages(),
  },
];
