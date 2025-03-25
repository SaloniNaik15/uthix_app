import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';
import 'package:uthix_app/view/login/email_id.dart';
import 'package:uthix_app/view/login/main_combine.dart';
import 'package:uthix_app/view/login/phone_otp.dart';

class NewRegisterlogin extends StatefulWidget {
  const NewRegisterlogin({super.key});

  @override
  State<NewRegisterlogin> createState() => _NewRegisterloginState();
}

class _NewRegisterloginState extends State<NewRegisterlogin> {
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
                    width: 120.w,
                    height: 130.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Welcome back! Log in to continue. First time here? Register to get started",
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contxet) => Registration()));
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
                          "Register",
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
                    height: 45.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (contxet) => NewLogin()));
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
