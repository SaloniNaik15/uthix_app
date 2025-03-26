import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_items.dart';

import 'package:uthix_app/view/instructor_dashboard/Profile/detail_profile.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_faq.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_helpdesk.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_manage.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/instructor_settings.dart';

import '../../../Logout.dart';
import '../../login/start_login.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAccount extends StatefulWidget {
  const ProfileAccount({super.key});

  @override
  State<ProfileAccount> createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  int selectedIndex = 3;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 3;
        });
      });
    }
  }

  final List<Map<String, String>> menuItems = [
    {"icon": "assets/account_profile/account-outline.png", "title": "Profile"},
    {
      "icon": "assets/account_profile/headset.png",
      "title": "Help Desk",
      "subtitle": "Connect with us"
    },
    {
      "icon": "assets/account_profile/pencil-box-outline.png",
      "title": "Manage Accounts",
      "subtitle": "Your account and saved addresses"
    },
    {
      "icon": "assets/account_profile/help-circle-outline.png",
      "title": "FAQs",
      "subtitle": "Frequently Asked Questions"
    },
    {
      "icon": "assets/account_profile/cog-outline.png",
      "title": "Settings",
      "subtitle": "Get notifications"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 25.sp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130.h,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xFFF6F6F6)),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Instructor",
                            style:TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 250.w,
                            child: Text(
                              "Congratulations! You are our premium member now",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 260.w,
                      child: Transform.rotate(
                        angle: -1.12 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/instructor/premium.png',
                          width: 128.w,
                          height: 130.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  height: 370.h,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Color(0xFFFCFCFC),
                    border: Border.all(color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10.h),
                    itemCount: menuItems.length,
                    separatorBuilder: (_, __) =>
                        Divider(thickness: 1, color: Color(0xFFD2D2D2)),
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return GestureDetector(
                        onTap: () {
                          if (item["title"] == "Profile") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailProfile()),
                            );
                          } else if (item["title"] == "Help Desk") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstructorHelpdesk()),
                            );
                          } else if (item["title"] == "Manage Accounts") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstructorManage()),
                            );
                          } else if (item["title"] == "FAQs") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstructorFaq()),
                            );
                          } else if (item["title"] == "Settings") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstructorSettings()),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 10.h),
                          child: Row(
                            children: [
                              Image.asset(item["icon"]!,
                                  width: 24.w, height: 24.h),
                              SizedBox(width: 15.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"]!,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  if (item.containsKey("subtitle"))
                                    Text(
                                      item["subtitle"]!,
                                      style:TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: MediaQuery.sizeOf(context).width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      logoutUser(context);
                    },
                    child: Text(
                      "Log out",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
