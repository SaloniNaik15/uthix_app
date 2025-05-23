import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/RoleSelection.dart';
import 'package:uthix_app/view/homeRegistration/mailIdPage.dart';
import 'package:uthix_app/view/homeRegistration/new_login.dart';
// import 'package:uthix_app/view/homeRegistration/successfulregister.dart';
// import 'package:uthix_app/view/login/start_login.dart';

import 'new_login.dart';

class Registration extends StatefulWidget {
  const Registration({
    super.key,
  });

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool ispassword = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset:
            false, // Prevents resizing when keyboard is open
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
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
                          Text(
                            "Welcome to UTHIX",
                            style:TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Are you a new User?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Be part of something great. Register Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 17.h),
                          SizedBox(
                            width: 225.w,
                            child: Text(
                              "You are just a few minutes away to access seamless online learning",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(96, 95, 95, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // Continue with Mail ID Button
                          buildButton(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Roleselection(),
                              ),
                            ),
                            iconPath: "assets/registration/gmail.png",
                            text: "Continue with Mail Id",
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "or",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            "Already have an account?",
                            style:TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(96, 95, 95, 1),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Login Button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewLogin(),
                                ),
                              );
                            },
                            child: Container(
                              height: 45.h,
                              width: 200.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: Color.fromRGBO(27, 97, 122, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "By logging in you are agreeing to our Terms and Conditions and Privacy Policy",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Ensures image stays at the bottom and does not move up when keyboard is open
              SizedBox(height: 20.h),
              Stack(
                children: [
                  Image.asset(
                    "assets/registration/collectionbooks.png",
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
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
        width: 250.w,
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
                  style: TextStyle(
                    fontSize: 16,
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
        style:TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
}
