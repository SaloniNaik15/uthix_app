// nav_items.dart
import 'package:flutter/material.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';

import '../UpcomingPage.dart';

final List<Map<String, dynamic>> navItems = [
  {
    "icon": Icons.home_outlined,
    "title": "Home",
    "page": InstructorDashboard(),
  },
  {
    "icon": Icons.folder_open_outlined,
    "title": "Files",
    "page": Files(),
  },
  {
    "icon": Icons.chat_outlined,
    "title": "Chat",
    "page": Chat(),
  },
  {
    "icon": Icons.person_outline,
    "title": "Profile",
    "page": const ProfileAccount(),
  },
];
