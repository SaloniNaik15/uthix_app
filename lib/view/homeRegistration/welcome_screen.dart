import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/login/email_id.dart';
import 'package:uthix_app/view/login/main_combine.dart';
import 'package:uthix_app/view/login/phone_otp.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<Map<String, String>> dashBoard = [
    {"image": "assets/registration/student.png", "title": "STUDENT"},
    {"image": "assets/registration/instructor.png", "title": "INSTRUCTOR "},
  ];
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => Scaffold(
        backgroundColor: Colors.white,
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
                  SizedBox(
                    height: 150.h,
                  ),
                  Image.asset(
                    "assets/registration/book.png",
                    width: 101.w,
                    height: 130.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Text(
                    "Welcome !",
                    style: GoogleFonts.urbanist(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemCount: dashBoard.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              switch (dashBoard[index]["title"]) {
                                case "STUDENT":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainCombine()),
                                  );
                                  break;
                                case "INSTRUCTOR":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstructorDashboard()),
                                  );
                                  break;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                    width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 106,
                                    child: Image.asset(
                                      dashBoard[index]["image"]!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      dashBoard[index]["title"]!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15.h,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
