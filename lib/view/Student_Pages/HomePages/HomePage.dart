// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Ecommerce/e_commerce.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/drawer_classroom.dart';
import 'package:uthix_app/view/Student_Pages/LMS/yourc_clasroom.dart';
import 'package:uthix_app/view/Student_Pages/Modern_Tools/modern_tools.dart';
import 'package:uthix_app/view/Student_Pages/Progress/progress_tracking.dart';
import 'package:uthix_app/view/Student_Pages/Student%20Account%20Details/Student_AccountPage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  int selectedIndex = 0;

  final List<Map<String, String>> dashBoard = [
    {"image": "assets/Student_Home_icons/Buy_Books.png", "title": "BUY BOOKS"},
    {
      "image": "assets/Student_Home_icons/My_Classes.png",
      "title": "MY CLASSES"
    },
    {
      "image": "assets/Student_Home_icons/My_Progress.png",
      "title": "MY PROGRESS"
    },
    {"image": "assets/Student_Home_icons/Community.png", "title": "COMMUNITY"},
    {
      "image": "assets/Student_Home_icons/Modern_tools.png",
      "title": "MODERN TOOLS"
    },
    {
      "image": "assets/Student_Home_icons/Demo_Classes.png",
      "title": "DEMO CLASSES"
    },
  ];

  String? accessLoginToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token
    log("Retrieved Token: $token"); // Log token for verification

    setState(() {
      accessLoginToken = token;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int drawerindex = 0;

    void onDrawerItemSelected(int index) {
      setState(() {
        drawerindex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0, // Ensures elements are properly aligned
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () =>
                  Scaffold.of(context).openDrawer(), // Open MyDrawer
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Mahima Mandal",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                  Text(
                    "MAHIMA 007",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              // Profile Image
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
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
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(
        onItemSelected: onDrawerItemSelected,
        selectedIndex: drawerindex,
        initialIndex: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 10,
            child: Image.asset(
              "assets/instructor/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1, // Adjust ratio to fit content better
                  ),
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                  itemCount: dashBoard.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (dashBoard[index]["title"] == "BUY BOOKS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuyTextBooks()),
                          );
                        } else if (dashBoard[index]["title"] == "MY CLASSES") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YourClasroom()),
                          );
                        } else if (dashBoard[index]["title"] ==
                            "MODERN TOOLS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModernTools()),
                          );
                        } else if (dashBoard[index]["title"] == "MY PROGRESS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProgressTracking()),
                          );
                        } else if (dashBoard[index]["title"] == "COMMUNITY") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UnderConstructionScreen()),
                          );
                        } else if (dashBoard[index]["title"] ==
                            "DEMO CLASSES") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UnderConstructionScreen()),
                          );
                        }
                      },
                      child: Container(
                        height: 162,
                        width: 162,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 117.6,
                              child: Image.asset(
                                dashBoard[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                dashBoard[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(96, 95, 95, 1),
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
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
                child: NavbarStudent(
                    onItemTapped: onItemTapped, selectedIndex: selectedIndex)),
          ),
        ],
      ),
    );
  }
}
