import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/homeRegistration/forgot1.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/new_registration.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/login/start_login.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({super.key});

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
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
                      SizedBox(height: 50.h),
                      Image.asset(
                        "assets/registration/book.png",
                        width: 101.w,
                        height: 130.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        "Welcome  BACK!",
                        style: GoogleFonts.urbanist(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Login to your account",
                        style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(height: 20.h),

                      // Continue with Mail ID Button
                      const SizedBox(height: 20),
                      _buildTextField(
                          controller: _emailIdController,
                          hint: "Please type your Email Id"),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgot1(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 30.w),
                            child: Text(
                              "Forgot Password",
                              style: GoogleFonts.urbanist(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePages(),
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
                              "Login",
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
                      Text(
                        "OR",
                        style: GoogleFonts.urbanist(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      Image.asset("assets/registration/google.png"),
                      SizedBox(height: 15.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewRegistration(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Register",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(27, 97, 122, 1),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromRGBO(27, 97, 122, 1),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 55.h),
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

  Widget _buildPasswordField() {
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
          controller: _passwordController,
          obscureText: ispassword,
          style:
              GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your Password",
            hintStyle:
                GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
            suffixIcon: IconButton(
              icon: Icon(ispassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () {
                setState(() {
                  ispassword = !ispassword;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  // Button Widget with Responsive Design
  Widget buildButton({
    required VoidCallback onTap,
    required String iconPath,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        width: 270.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(175, 175, 175, 1),
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath, width: 24.w, height: 24.h),
                SizedBox(width: 10.w),
                Text(
                  text,
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
    );
  }
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
        style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w400),
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
