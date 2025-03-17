import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentHelpdesk extends StatefulWidget {
  const StudentHelpdesk({super.key});

  @override
  State<StudentHelpdesk> createState() => _StudentHelpdeskState();
}

class _StudentHelpdeskState extends State<StudentHelpdesk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: const Color(0xFF605F5F),
                  size: 20.sp,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 30.h,
              right: -10.w,
              child: Image.asset(
                'assets/icons/FrequentlyAsked Questions.png', // Replace with your image path
                width: 70.w,
                height: 70.h,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Help Desk",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 220.w,
                    child: const Text(
                        "Please contact us and we will be \n  happy to help you"),
                  ),
                  Card(
                    child: Image.asset(
                      'assets/icons/HelpDesk.png',
                      width: 90.w,
                      height: 90.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(height: 1),
              SizedBox(height: 20.h),
              Text(
                "Raise a Query",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              const Divider(height: 1),
              SizedBox(height: 20.h),
              Text(
                "Subject",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              TextField(
                decoration: InputDecoration(
                  hintText: "Start typing...",
                  filled: true,
                  hintStyle: TextStyle(fontSize: 14.sp),
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFD2D2D2),
                      width: 1.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Description",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Start Typing...',
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFD2D2D2),
                      width: 1.w,
                    ),
                  ),
                ),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
              ),
              SizedBox(height: 25.h),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "We will answer your query asap.",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 80.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: SizedBox(
                    height: 50.h,
                    width: 100.w,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF605F5F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        print("Outlined Button Pressed!");
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
