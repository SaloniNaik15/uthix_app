import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/forgot4.dart';

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
    return  Scaffold(
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
              // Centered scrollable content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Top Spacing
                            SizedBox(height: 30.h),
                            // Book Image
                            Image.asset(
                              "assets/registration/book.png",
                              width: 90.w,
                              height:114.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 50.h),
                            // Title
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // New Password
                            _buildTextField(
                              controller: _passwordController,
                              hint: "Please type your new password",
                            ),
                            SizedBox(height: 20.h),
                            // Confirm Password
                            _buildTextField(
                              controller: _confirmController,
                              hint: "Confirm password",
                            ),
                            SizedBox(height: 25.h),
                            // Save Password Button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Forgot4(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45.h,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  color: const Color.fromRGBO(27, 97, 122, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save password",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Bottom Spacing
                            //SizedBox(height: 50.h),
                          ],
                        ),
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
      height: 50.h,
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
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle:TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
