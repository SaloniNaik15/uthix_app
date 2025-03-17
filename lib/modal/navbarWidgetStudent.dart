import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';

class NavbarStudent extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NavbarStudent({
    required this.onItemTapped,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      height: 59.h, // Responsive height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          navStudItems.length,
          (index) => GestureDetector(
            onTap: () => onItemTapped(index),
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: Offset(0, 8.h),
                    blurRadius: 16.r,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: Offset(0, 0),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    navStudItems[index]["icon"],
                    size: 20.sp, // Responsive icon size
                    color: selectedIndex == index
                        ? Colors.blue
                        : const Color.fromRGBO(96, 95, 95, 1),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    navStudItems[index]["title"],
                    style: GoogleFonts.urbanist(
                      fontSize: 10.sp, // Responsive font size
                      fontWeight: FontWeight.w400,
                      color: selectedIndex == index
                          ? Colors.blue
                          : const Color.fromRGBO(96, 95, 95, 1),
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
}
