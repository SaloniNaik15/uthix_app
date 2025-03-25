import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/forgot3.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/login/start_login.dart';

class Forgot2 extends StatefulWidget {
  const Forgot2({super.key});

  @override
  State<Forgot2> createState() => _Forgot2State();
}

class _Forgot2State extends State<Forgot2> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();
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

                      SizedBox(height: 15.h),
                      Text(
                        "Please, check m**I@e*****e.com for your Verification Code",
                        style: GoogleFonts.urbanist(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),

                      // Continue with Mail ID Button
                      const SizedBox(height: 20),
                      Row(
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(246, 246, 246, 1),
                                border: Border.all(
                                  color: const Color.fromRGBO(210, 210, 210, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: [
                                  _digit1Controller,
                                  _digit2Controller,
                                  _digit3Controller,
                                  _digit4Controller
                                ][index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(96, 95, 95, 1),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(height: 20.h),

                      // Login Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgot3(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50.h,
                          width: 270.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: Color.fromRGBO(27, 97, 122, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Verify",
                              style: GoogleFonts.urbanist(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

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
