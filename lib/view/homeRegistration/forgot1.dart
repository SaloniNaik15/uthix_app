import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/forgot2.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/login/start_login.dart';

class Forgot1 extends StatefulWidget {
  const Forgot1({super.key});

  @override
  State<Forgot1> createState() => _Forgot1State();
}

class _Forgot1State extends State<Forgot1> {
  final TextEditingController _emailIdController = TextEditingController();
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
                        "Forgot Password",
                        style: GoogleFonts.urbanist(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Reset Your Password in a Few Steps",
                        style: GoogleFonts.urbanist(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),

                      // Continue with Mail ID Button
                      const SizedBox(height: 20),
                      _buildTextField(
                          controller: _emailIdController,
                          hint: "Please type your Email Id"),
                      const SizedBox(height: 20),

                      SizedBox(height: 20.h),

                      // Login Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgot2(),
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
                              "Send code",
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
      height: 45,
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
