import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:uthix_app/view/homeRegistration/forgot2.dart';

import '../../modal/Snackbar.dart';

class Forgot1 extends StatefulWidget {
  const Forgot1({super.key});

  @override
  State<Forgot1> createState() => _Forgot1State();
}

class _Forgot1State extends State<Forgot1> {
  final TextEditingController _emailIdController = TextEditingController();

  Future<void> sendCode() async {
    final email = _emailIdController.text.trim();

    if (email.isEmpty) {
      SnackbarHelper.showMessage(
        context,
        message: "Please enter your email",
      );
      return;
    }

    final dio = Dio();
    const String apiUrl = "https://admin.uthix.com/api/forgot-password";

    try {
      final response = await dio.post(apiUrl, data: {"email": email});

      if (response.statusCode == 200) {
        SnackbarHelper.showMessage(
          context,
          message: "Code sent successfully!",
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Forgot2()),
        );
      } else {
        SnackbarHelper.showMessage(
          context,
          message: "Error: ${response.statusMessage}",
        );
      }
    } on DioException catch (dioError) {
      final errorMessage = dioError.response != null
          ? "Error: ${dioError.response?.statusMessage}"
          : "Error: ${dioError.message}";
      SnackbarHelper.showMessage(
        context,
        message: errorMessage,
      );
    } catch (e) {
      SnackbarHelper.showMessage(
        context,
        message: "An unexpected error occurred: $e",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
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
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/registration/book.png",
                        width: 90.w,
                        height: 114.h,
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Reset Your Password in a Few Steps",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25.h),
                      _buildTextField(
                        controller: _emailIdController,
                        hint: "Enter your email",
                      ),
                      SizedBox(height: 25.h),
                      GestureDetector(
                        onTap: sendCode,
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: const Color.fromRGBO(27, 97, 122, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Send code",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color.fromRGBO(210, 210, 210, 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
