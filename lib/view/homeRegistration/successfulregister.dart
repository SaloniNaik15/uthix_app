import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Seller_dashboard/User_setting/Profile.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';
import 'package:uthix_app/view/homeRegistration/profile.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';
import 'package:uthix_app/view/login/email_id.dart';
import 'package:uthix_app/view/login/main_combine.dart';
import 'package:uthix_app/view/login/phone_otp.dart';

class Successfulregister extends StatefulWidget {
  const Successfulregister({super.key});

  @override
  State<Successfulregister> createState() => _SuccessfulregisterState();
}

class _SuccessfulregisterState extends State<Successfulregister> {
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
                    height: 200.h,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Successfully Registered!!",
                      style: GoogleFonts.urbanist(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 55.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (contxet) => NewLogin(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50.h,
                      width: 270.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(175, 175, 175, 1),
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          color: Color.fromRGBO(27, 97, 122, 1)),
                      child: Center(
                        child: Text(
                          "Login Now",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contxet) => RegisterProfile()));
                    },
                    child: Container(
                      height: 50.h,
                      width: 270.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(175, 175, 175, 1),
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          color: Color.fromRGBO(27, 97, 122, 1)),
                      child: Center(
                        child: Text(
                          "Complete your Profile",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 70.w, top: 2.h),
                      child: Text(
                        "Skip (I want to do it later)",
                        style: GoogleFonts.urbanist(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
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
