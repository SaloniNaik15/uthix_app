import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';

class panding extends StatefulWidget {
  const panding({super.key});

  @override
  State<panding> createState() => _pandingState();
}

class _pandingState extends State<panding> {
  /// Intercept both system and AppBar back presses
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewLogin()),
    );
    return false; // prevent default pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // background image with opacity
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
                      children: [
                        Image.asset("assets/registration/book.png"),
                        SizedBox(height: 50.h),
                        Text(
                          "VERIFICATION DUE !",
                          style: TextStyle(fontSize: 30.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Admin will contact you for access to your profile in 2 working days.",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
