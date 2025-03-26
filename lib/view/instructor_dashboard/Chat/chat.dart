import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_items.dart';
import 'package:uthix_app/modal/navbarWidgetInstructor.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/new_chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Chat/personal_chat.dart';
import 'package:uthix_app/view/instructor_dashboard/Dashboard/instructor_dashboard.dart';
import 'package:uthix_app/view/instructor_dashboard/Profile/profile_account.dart';
import 'package:uthix_app/view/instructor_dashboard/files/files.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int selectedIndex = 2;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 2;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.h),
            child: AppBar(
              backgroundColor: const Color(0xFF2B5C74),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                "Chat",
                style: GoogleFonts.urbanist(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 70.h, top: 40.h),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalChat()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/login/profile.jpeg",
                                width: 50.w,
                                height: 50.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Name",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Text("Date",
                                          style:TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Lorem ipsum dolor sit amet",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(51, 152, 246, 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 100.h,
                right: 30.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewChat()),
                    );
                  },
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 92, 116, 1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8),
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.chat_bubble,
                          size: 25.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Navbar(
                      onItemTapped: onItemTapped, selectedIndex: selectedIndex),
                ),
              ),
            ],
          ),
        ),

        // Gradient Container Positioned Half in AppBar and Half in Body
        Positioned(
          top:
              74.h, // Adjust this value to control how much is above the AppBar
          left: MediaQuery.of(context).size.width / 2 -
              50.w, // Centering the circle
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45.r),
                  child: Image.asset("assets/icons/profile.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
