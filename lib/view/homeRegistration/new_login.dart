import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/homeRegistration/forgot1.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/new_registration.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';
import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
import 'package:uthix_app/view/instructor_dashboard/panding.dart';
import 'package:uthix_app/view/login/start_login.dart';

import '../Seller_dashboard/dashboard.dart';
import '../instructor_dashboard/Dashboard/instructor_dashboard.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({super.key});

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool ispassword = true;

  Future<void> saveUserSession(String token, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', role);
  }

  void _login() async {
    String email = _emailIdController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter email and password",
            style: GoogleFonts.urbanist(),
          ),
        ),
      );
      return;
    }

    try {
      final Dio dio = Dio();

      final response = await dio.post(
        'https://admin.uthix.com/api/login',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {"email": email, "password": password},
      );

      log("API Response: ${response.data}");

      final data = response.data;

      if (response.statusCode == 403 &&
          data['status']?.toLowerCase() == 'pending') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => panding()),
        );
        return;
      }

      if (response.statusCode == 200 &&
          data['status']?.toLowerCase() == 'approved' &&
          data.containsKey('access_token')) {
        String token = data['access_token'];
        String role = data['role'] ?? 'student';

        await saveUserSession(token, role);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        log("Stored Token: ${prefs.getString('auth_token')}, Role: ${prefs.getString('user_role')}");

        Widget nextScreen;

        if (role == 'seller') {
          nextScreen = SellerDashboard();
        } else if (role == 'instructor') {
          nextScreen = InstructorDashboard();
        } else {
          nextScreen = HomePages();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? "Invalid email or password",
              style: GoogleFonts.urbanist(),
            ),
          ),
        );
      }
    } on DioError catch (dioError) {
      // 👇 Handle specific API failure
      if (dioError.response != null) {
        log("Dio Error Response: ${dioError.response?.data}");
        final data = dioError.response?.data;

        if (dioError.response?.statusCode == 403 &&
            data?['status']?.toLowerCase() == 'pending') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => panding()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data?['message'] ?? "Invalid email or password",
                style: GoogleFonts.urbanist(),
              ),
            ),
          );
        }
      } else {
        // 👇 Network error / timeout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Network error. Please check your connection.",
              style: GoogleFonts.urbanist(),
            ),
          ),
        );
      }
    } catch (e) {
      // 👇 Fallback for any other unexpected errors
      log("Unexpected Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An unexpected error occurred. Please try again.",
            style: GoogleFonts.urbanist(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Registration()),
        );
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(320, 812),
        builder: (_, child) => Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.30,
                      child: Image.asset(
                        "assets/registration/splash.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Centered content with scroll capability
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/registration/book.png",
                              // width: 200.w,
                              // height: 200.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Welcome BACK!",
                              style: GoogleFonts.urbanist(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Login to your account",
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            _buildTextField(
                                controller: _emailIdController,
                                hint: "Enter your Email"),
                            SizedBox(height: 20.h),
                            _buildPasswordField(),
                            SizedBox(height: 20.h),
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
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                            GestureDetector(
                              onTap: _login,
                              child: Container(
                                height: 45.h,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  color: Color.fromRGBO(27, 97, 122, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 45.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Registration(),
                                  ),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Register",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12.sp,
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
                    ),
                  ),
                ],
              ),
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
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
}) {
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
