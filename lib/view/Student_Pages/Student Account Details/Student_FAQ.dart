import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentFaq extends StatefulWidget {
  const StudentFaq({super.key});

  @override
  State<StudentFaq> createState() => _StudentFaqState();
}

class _StudentFaqState extends State<StudentFaq> {
  // List to store the expanded state for each list item
  final List<bool> _expandedStates = List.filled(8, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
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
              top: 40.h,
              right: -10.w,
              child: Image.asset(
                'assets/icons/FrequentlyAsked Questions.png', // Replace with your image path
                width: 80.w,
                height: 80.h,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: const Color(0xFFD9D9D9), width: 1.w),
                ),
                child: Column(
                  children: List.generate(8, (index) {
                    return Column(
                      children: [
                        _buildListTile(
                          index: index,
                          title:
                          "What is the required time duration for an order to get delivered?",
                        ),
                        if (_expandedStates[index])
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Text(
                              "What is the required time duration for an order to get delivered?",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Divider(height: 1.h),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required int index,
    required String title,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        _expandedStates[index]
            ? Icons.keyboard_arrow_up_outlined
            : Icons.keyboard_arrow_down_outlined,
        size: 25.sp,
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          _expandedStates[index] = !_expandedStates[index];
        });
      },
    );
  }
}
