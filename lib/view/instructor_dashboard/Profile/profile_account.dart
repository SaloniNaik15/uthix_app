// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/detail_profile.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_faq.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_helpdesk.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_manage.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_settings.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';

import '../../login/start_login.dart';

class ProfileAccount extends StatefulWidget {
  const ProfileAccount({super.key});

  @override
  State<ProfileAccount> createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  int selectedIndex = 3;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 3;
        });
      });
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');

    // Navigate to Login Screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartLogin()),
    );
  }

  final List<Map<String, dynamic>> navItems = [
    {
      "icon": Icons.home_outlined,
      "title": "Home",
      "page": InstructorDashboard()
    },
    {"icon": Icons.folder_open_outlined, "title": "Files", "page": Files()},
    {
      "icon": Icons.chat_outlined,
      "title": "Chat",
      "page": UnderConstructionScreen()
    },
    {
      "icon": Icons.person_outline,
      "title": "Profile",
      "page": const ProfileAccount()
    },
  ];

  final List<Map<String, String>> menuItems = [
    {"icon": "assets/account_profile/account-outline.png", "title": "Profile"},
    {
      "icon": "assets/account_profile/headset.png",
      "title": "Help Desk",
      "subtitle": "Connect with us"
    },
    {
      "icon": "assets/account_profile/pencil-box-outline.png",
      "title": "Manage Accounts",
      "subtitle": "Your account and saved addresses"
    },
    {
      "icon": "assets/account_profile/help-circle-outline.png",
      "title": "FAQs",
      "subtitle": "Frequently Asked Questions"
    },
    {
      "icon": "assets/account_profile/cog-outline.png",
      "title": "Settings",
      "subtitle": "Get notifications"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 30,
                ),
                Text(
                  "Your Profile",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 130,
            width: 420,
            decoration: BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Mahima",
                        style: GoogleFonts.urbanist(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          "Congratulations! You are our premium member now",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 289,
                  child: Transform.rotate(
                    angle: -1.12 * (3.14159 / 180),
                    child: Opacity(
                      opacity: 1,
                      child: Image.asset(
                        'assets/instructor/premium.png',
                        width: 128,
                        height: 128,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 370,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(252, 252, 252, 1),
                border:
                    Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10),
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const Divider(
                    thickness: 1, color: Color.fromRGBO(210, 210, 210, 1)),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () {
                      if (item["title"] == "Profile") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailProfile()),
                        );
                      } else if (item["title"] == "Help Desk") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorHelpdesk()),
                        );
                      } else if (item["title"] == "Manage Accounts") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorManage()),
                        );
                      } else if (item["title"] == "FAQs") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorFaq()),
                        );
                      } else if (item["title"] == "Settings") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorSettings()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset(item["icon"]!, width: 24, height: 24),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              if (item.containsKey("subtitle"))
                                Text(
                                  item["subtitle"]!,
                                  style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Colors.red,
                        width: 1), // Border color & thickness
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    logoutUser(context);
                  },
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Navbar(
                onItemTapped: onItemTapped, selectedIndex: selectedIndex),
          ),
        ],
      ),
    );
  }
}
