import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/login/email_id.dart';
import 'package:uthix_app/view/login/main_combine.dart';
import 'package:uthix_app/view/login/phone_otp.dart';

class StartLogin extends StatefulWidget {
  const StartLogin({super.key});

  @override
  State<StartLogin> createState() => _StartLoginState();
}

class _StartLoginState extends State<StartLogin> {
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EmailId()));
                    },
                    child: Container(
                      height: 45.h,
                      width: 270.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(175, 175, 175, 1),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Aligns content to the center
                            children: [
                              Image.asset("assets/registration/gmail.png"),
                              SizedBox(
                                  width: 15
                                      .w), // Adds space between the image and text
                              Text(
                                "Continue with Mail Id",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(175, 175, 175, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => PhoneOtp()));
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 277,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Color.fromRGBO(175, 175, 175, 1),
                  //       ),
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(5),
                  //       child: Row(
                  //         children: [
                  //           Image.asset("assets/registration/phone.png"),
                  //           const SizedBox(
                  //             width: 30,
                  //           ),
                  //           Text(
                  //             "Use your  Phone Number",
                  //             style: GoogleFonts.urbanist(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w400,
                  //               color: Color.fromRGBO(175, 175, 175, 1),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 100.h,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 45.h,
                      width: 270.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(175, 175, 175, 1),
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          color: Color.fromRGBO(27, 97, 122, 1)),
                      child: Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
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
