import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/homeRegistration/forgot1.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';
import 'package:uthix_app/view/instructor_dashboard/panding.dart';
import '../../modal/Snackbar.dart';
import '../Seller_dashboard/dashboard.dart';
import '../Student_Pages/Student Account Details/Student_Profile.dart';
import '../instructor_dashboard/Profile/detail_profile.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({super.key});

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordHidden = true;

  Future<void> saveUserSession(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', role);
  }

  Future<Object?> _login() async {
    final email = _emailIdController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      SnackbarHelper.showMessage(
        context,
        message: "Please enter email and password",
      );
      return null;
    }

    try {
      final dio = Dio();
      final loginResp = await dio.post(
        'https://admin.uthix.com/api/login',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {"email": email, "password": password},
      );

      final loginData = loginResp.data as Map<String, dynamic>;

      // Pending
      if (loginResp.statusCode == 403 &&
          (loginData['status'] as String).toLowerCase() == 'pending') {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const panding()),
        );
      }

      // Approved + token
      if (loginResp.statusCode == 200 &&
          (loginData['status'] as String).toLowerCase() == 'approved' &&
          loginData.containsKey('access_token')) {
        final token = loginData['access_token'] as String;
        final role = (loginData['role'] as String?) ?? 'student';

        await saveUserSession(token, role);
        log("Stored Token: $token, Role: $role");

        dio.options.headers['Authorization'] = 'Bearer $token';

        Widget nextScreen;
        if (role == 'seller') {
          nextScreen = const SellerDashboard();
        } else if (role == 'instructor') {
          nextScreen = const DetailProfile();
        } else {
          // Student: fetch profile and check classroom_id
          final profResp = await dio.get('https://admin.uthix.com/api/student-profile');
          if (profResp.statusCode == 200 && profResp.data['status'] == true) {
            final profData = profResp.data['data'] as Map<String, dynamic>;
            final int? classId = profData['classroom_id'] as int?;
            nextScreen = (classId == null)
                ? const StudentProfile()
                : const HomePages();
          } else {
            // Fallback if profile call fails
            nextScreen = const StudentProfile();
          }
        }

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      }

      // Invalid credentials
      SnackbarHelper.showMessage(
        context,
        message: loginData['message'] ?? "Invalid email or password",
      );
      return null;
    } on DioException catch (dioError) {
      final msg = dioError.response?.data['message'] ??
          "Network error. Please try again.";
      SnackbarHelper.showMessage(
        context,
        message: msg,
      );
      return null;
    } catch (e) {
      SnackbarHelper.showMessage(
        context,
        message: "Unexpected error: $e",
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Registration()),
        );
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(320, 812),
        builder: (_, __) => Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/registration/splash.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/registration/book.png",
                              width: 90.w,
                              height: 114.h,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Welcome BACK!",
                              style: GoogleFonts.openSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Login to your account",
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                                  MaterialPageRoute(builder: (_) => const Forgot1()),
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            GestureDetector(
                              onTap: _login,
                              child: Container(
                                height: 45.h,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  color: const Color(0xFF2B5C74),
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 45),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Registration()),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.openSans(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: "Register",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: const Color(0xFF1B617A),
                                        decoration: TextDecoration.underline,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFD2D2D2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFD2D2D2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _passwordController,
          obscureText: isPasswordHidden,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your Password",
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  isPasswordHidden = !isPasswordHidden;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}