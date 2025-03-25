import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/forgot2.dart';
import 'package:uthix_app/view/homeRegistration/forgot4.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/login/start_login.dart';

class Forgot3 extends StatefulWidget {
  const Forgot3({super.key});

  @override
  State<Forgot3> createState() => _Forgot3State();
}

class _Forgot3State extends State<Forgot3> {
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
                      Image.asset(
                        "assets/registration/book.png",
                        width: 101.w,
                        height: 130.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 50.h),

                      Text(
                        "Reset Password",
                        style: GoogleFonts.urbanist(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: 15.h),

                      SizedBox(height: 30.h),

                      _buildTextField(
                          controller: _passwordController,
                          hint: "Please type your new password"),
                      SizedBox(height: 20.h),
                      _buildTextField(
                          controller: _confirmController,
                          hint: "Confirm password"),
                      const SizedBox(height: 20),

                      SizedBox(height: 20.h),

                      // Login Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgot4(),
                            ),
                          );
                        },
                        child: Container(
                          height: 45.h,
                          width: 270.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: Color.fromRGBO(27, 97, 122, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Save password",
                              style: GoogleFonts.urbanist(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 150.h),
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
