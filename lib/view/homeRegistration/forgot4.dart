import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/forgot2.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/login/start_login.dart';

class Forgot4 extends StatefulWidget {
  const Forgot4({super.key});

  @override
  State<Forgot4> createState() => _Forgot4State();
}

class _Forgot4State extends State<Forgot4> {
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool ispassword = true;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(320, 812),
      builder: (_, child) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset:
            false, // Prevents resizing when keyboard is open
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100.h),
                      Container(
                        width: 150.w, // Outer circle size
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 209, 207, 207), // Grey outer circle
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 128.w, // Inner circle size
                            height: 128.h,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                  27, 97, 122, 1), // Green inner circle
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check, // Right tick icon
                                color: Colors.white, // White color
                                size: 40.sp, // Icon size
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),

                      Text(
                        "Your Password has been Successfully Changed",
                        style: GoogleFonts.urbanist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50.h),
                      // Login Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewLogin(),
                            ),
                          );
                        },
                        child: Container(
                          height: 55.h,
                          width: 270.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: Color.fromRGBO(27, 97, 122, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Back to Login",
                              style: GoogleFonts.urbanist(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 450.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hint}) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style:
              GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle:
                GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
