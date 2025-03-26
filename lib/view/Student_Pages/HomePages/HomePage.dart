import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/drawer_classroom.dart';
import 'package:uthix_app/view/Student_Pages/LMS/yourc_clasroom.dart';
import 'package:uthix_app/view/Student_Pages/Modern_Tools/modern_tools.dart';
import 'package:uthix_app/view/Student_Pages/Progress/progress_tracking.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  int selectedIndex = 0;
  String? accessLoginToken;
  String? userName;

  final List<Map<String, String>> dashBoard = [
    {"image": "assets/Student_Home_icons/Buy_Books.png", "title": "BUY BOOKS"},
    {"image": "assets/Student_Home_icons/My_Classes.png", "title": "MY CLASSES"},
    {"image": "assets/Student_Home_icons/My_Progress.png", "title": "MY PROGRESS"},
    {"image": "assets/Student_Home_icons/Community.png", "title": "COMMUNITY"},
    {"image": "assets/Student_Home_icons/Modern_tools.png", "title": "MODERN TOOLS"},
    {"image": "assets/Student_Home_icons/Demo_Classes.png", "title": "DEMO CLASSES"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    log("Retrieved Token: $token");

    setState(() {
      accessLoginToken = token;
    });

    // Load cached profile first
    await _loadProfileFromCache();
    // Then fetch updated profile data from API
    _fetchUserProfile();
  }

  Future<void> _loadProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedProfile = prefs.getString("cached_profile");
    if (cachedProfile != null) {
      try {
        final data = jsonDecode(cachedProfile);
        setState(() {
          userName = data["name"];
        });
        log("Loaded profile from cache.");
      } catch (e) {
        log("Error decoding cached profile: $e");
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final dio = Dio();
      // Replace with your actual API endpoint.
      final response = await dio.get(
        "https://admin.uthix.com/api/profile",
        options: Options(
          headers: {"Authorization": "Bearer $accessLoginToken"},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          userName = data["name"];
        });
        // Cache the fetched profile data.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cached_profile", jsonEncode(data));
        log("Profile updated from API and cached.");
      } else {
        log("Failed to fetch user profile: ${response.statusMessage}");
      }
    } catch (e) {
      log("Error fetching user profile: $e");
    }
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
          titleSpacing: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display fetched userName; fallback to placeholder if not available.
                  Text(
                    userName ?? "...",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(96, 95, 95, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Container(
                height: 50,
                width: 50,
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
              const SizedBox(width: 15),
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
            top: 50.h,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dashBoard.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (dashBoard[index]["title"] == "BUY BOOKS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnderConstructionScreen(),
                            ),
                          );
                        } else if (dashBoard[index]["title"] == "MY CLASSES") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YourClasroom(),
                            ),
                          );
                        } else if (dashBoard[index]["title"] == "MODERN TOOLS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModernTools(),
                            ),
                          );
                        } else if (dashBoard[index]["title"] == "MY PROGRESS") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgressTracking(),
                            ),
                          );
                        } else if (dashBoard[index]["title"] == "COMMUNITY") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnderConstructionScreen(),
                            ),
                          );
                        } else if (dashBoard[index]["title"] == "DEMO CLASSES") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnderConstructionScreen(),
                            ),
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
                                style: TextStyle(
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
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: NavbarStudent(
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
