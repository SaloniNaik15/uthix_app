import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';

class panding extends StatefulWidget {
  const panding({super.key});

  @override
  State<panding> createState() => _pandingState();
}

class _pandingState extends State<panding> {
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
          onPressed: () => Navigator.pop(context,
              MaterialPageRoute(builder: (context) => NewLogin())),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Full-screen background image with opacity
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/registration/book.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        "VERIFICATION DUE !",
                        style: TextStyle(fontSize: 30.sp),
                        textAlign: TextAlign.center, // 👈 Center align this text
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w), // Optional for spacing
                        child: Text(
                          "Admin will contact you for access to your profile in 2 working days.",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.center, // 👈 Center align this text too
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
}
