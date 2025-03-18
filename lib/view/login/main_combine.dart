import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Ecommerce/e_commerce.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';

class MainCombine extends StatefulWidget {
  const MainCombine({super.key});

  @override
  State<MainCombine> createState() => _MainCombineState();
}

class _MainCombineState extends State<MainCombine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
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
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   SizedBox(
                    height: 200.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ECommerce()));
                    },
                    child: Container(
                      height: 204,
                      width: 163,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 166,
                            width: 166,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(207, 207, 207, 1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.08),
                                  offset: Offset(0, 8),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.04),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Image.asset("assets/login/store.png",
                                height: 164, width: 164),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Education Store",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePages()));
                    },
                    child: Container(
                      height: 204,
                      width: 163,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 166,
                            width: 166,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(207, 207, 207, 1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.08),
                                  offset: Offset(0, 8),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.04),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              "assets/login/elearning.png",
                              height: 111,
                              width: 167,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "E-Learning",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
