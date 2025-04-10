import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/view/homeRegistration/registration.dart';

import 'mailIdPage.dart';

class Roleselection extends StatelessWidget {
  const Roleselection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.4,
              image: AssetImage("assets/registration/splash.png"), // Your light pattern bg
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Image.asset(
                "assets/registration/book.png", // Your logo image
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 30.h),
              // Welcome text
              Text(
                "Welcome !",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Now I want to use app as a",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30.h),
              // Options Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionCard(
                      imagePath: "assets/registration/Student_logo.png",
                      label: "STUDENT",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mailidpage(role: "student"),
                          ),
                        );
                      },
                    ),
                    _buildOptionCard(
                      imagePath: "assets/registration/Instructor_logo.png",
                      label: "INSTRUCTOR",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mailidpage(role: "instructor"),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20.h),
               _buildOptionCard(
                  imagePath: "assets/registration/Seller.png",
                  label: "Vendor",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mailidpage(role: "seller"),
                      ),
                    );
                  },
                ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildOptionCard({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 50.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}