import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/dashboard.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/login/start_login.dart';
import 'package:uthix_app/view/homeRegistration/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Successpage extends StatefulWidget {
  const Successpage({super.key});

  @override
  State<Successpage> createState() => _SuccesspageState();
}

class _SuccesspageState extends State<Successpage> {
  bool onclickLogin = false;
  bool onclickProfile = false;
  String? userRole;
  String? accessToken;
  String? userName;
  String? userEmail;
  String? userPassword;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// 🔹 Load user data from SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("userRole");
      accessToken = prefs.getString("userToken");
      userName = prefs.getString("userName");
      userEmail = prefs.getString("userEmail");
      userPassword = prefs.getString("userPassword");
    });
  }

  /// 🔹 Login function (example API call)

  /// 🔹 Navigate to the appropriate dashboard
  void navigateToDashboard() {
    if (accessToken != null && accessToken!.isNotEmpty) {
      Widget nextPage;
      switch (userRole) {
        case 'seller':
          nextPage = SellerDashboard();
          break;
        case 'instructor':
          nextPage = InstructorDashboard();
          break;
        case 'student':
          nextPage = StartLogin();
          break;
        default:
          nextPage = StartLogin();
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => nextPage),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StartLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset("assets/registration/splash.png",
                  fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  "assets/registration/book.png",
                  width: 111,
                  height: 115,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 100),
                Text(
                  "Hi ${userName ?? "User"}",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  "Successfully Registered!",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                const SizedBox(height: 50),

                /// 🔹 Login Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      onclickLogin = true;
                    });
                    navigateToDashboard();
                  },
                  child: Container(
                    height: 50,
                    width: 277,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(175, 175, 175, 1),
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: (onclickLogin)
                          ? const Color.fromRGBO(142, 140, 140, 1)
                          : const Color.fromRGBO(27, 97, 122, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Login Now",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /// 🔹 Profile Completion Button
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      onclickProfile = true;
                    });

                    // Example user data (replace with actual user input)
                    String email = "yourEmail@example.com";
                    String password = "yourPassword";

                    // Save email and password in SharedPreferences

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => RegisterProfile()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 277,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(175, 175, 175, 1),
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: (onclickProfile)
                          ? const Color.fromRGBO(142, 140, 140, 1)
                          : const Color.fromRGBO(27, 97, 122, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Complete your profile",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 78),
                    child: Text(
                      "SKIP (I want to do it later)",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(51, 152, 246, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
