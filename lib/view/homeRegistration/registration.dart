import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/successPage.dart';
import 'package:uthix_app/view/homeRegistration/successPhone.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double imageHeight = screenHeight * 0.25; // 25% of screen height

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.30,
                    child: Image.asset(
                      "assets/registration/splash.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 45),
                    Text(
                      " Welcome to UTHIX",
                      style: GoogleFonts.urbanist(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Are you a new User?",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    Text(
                      "Create an Account",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: 225,
                      child: Text(
                        "You are just a few minutes away to access seamless online learning",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Successpage())),
                      iconPath: "assets/registration/google.png",
                      text: "Continue with Google",
                    ),
                    const SizedBox(height: 10),
                    buildButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Successpage())),
                      iconPath: "assets/registration/facebook.png",
                      text: "Continue with Facebook",
                    ),
                    const SizedBox(height: 10),
                    buildButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Mailidpage())),
                      iconPath: "assets/registration/gmail.png",
                      text: "Continue with Mail Id",
                    ),
                    const SizedBox(height: 10),
                    buildButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Successphone())),
                      iconPath: "assets/registration/phone.png",
                      text: "Use your Phone Number",
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(96, 95, 95, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 277,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromRGBO(27, 97, 122, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 276,
                      child: Text(
                        "By logging in you are agreeing to our Terms and Conditions and Privacy Policy",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Fixed Bottom Image with Dynamic Height
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/registration/collectionbooks.png",
              fit: BoxFit.cover, // Ensures image remains fully visible
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required VoidCallback onTap,
    required String iconPath,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 277,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(175, 175, 175, 1),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 24),
              const SizedBox(width: 15),
              Text(
                text,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(175, 175, 175, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
