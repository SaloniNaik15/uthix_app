import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorSettings extends StatefulWidget {
  const InstructorSettings({Key? key}) : super(key: key);

  @override
  State<InstructorSettings> createState() => _InstructorSettingsState();
}

class _InstructorSettingsState extends State<InstructorSettings> {
  bool isNotificationsEnabled = false;
  bool isOptimizedExperienceEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: const Color(0xFF605F5F),
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title "Settings"
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Divider below title
          Divider(
            thickness: 1.h,
            color: Colors.grey[300],
          ),
          // First Checkbox ListTile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CheckboxListTile(
              title: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "This will not affect any order updates",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: isNotificationsEnabled,
              onChanged: (bool? newValue) {
                setState(() {
                  isNotificationsEnabled = newValue!;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          // Divider below checkbox
          Divider(
            thickness: 1.h,
            color: Colors.grey[300],
          ),
          // Second Checkbox ListTile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CheckboxListTile(
              title: Text(
                "Optimized Experience",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "For optimized connection quality",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: isOptimizedExperienceEnabled,
              onChanged: (bool? newValue) {
                setState(() {
                  isOptimizedExperienceEnabled = newValue!;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          // Final Divider
          Divider(
            thickness: 1.h,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
