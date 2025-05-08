import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modal/Snackbar.dart';

class StudentFaq extends StatefulWidget {
  const StudentFaq({super.key});

  @override
  State<StudentFaq> createState() => _StudentFaqState();
}

class _StudentFaqState extends State<StudentFaq> {
  List<dynamic> _faqList = [];
  List<bool> _expandedStates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFaqList();
  }

  Future<void> fetchFaqList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        SnackbarHelper.showMessage(
          context,
          message: 'Authentication failed. Please log in again.',
        );
        return;
      }

      Dio dio = Dio();
      const String apiUrl = "https://admin.uthix.com/api/faqs/active"; // 🔁 Replace

      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _faqList = response.data; // ✅ JSON is a list
          _expandedStates = List.filled(_faqList.length, false);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load FAQs");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackbarHelper.showMessage(
        context,
        message: 'Error fetching FAQs: $e',
      );
    }
  }

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
                'assets/icons/FrequentlyAsked Questions.png',
                width: 80.w,
                height: 80.h,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _faqList.isEmpty
          ? const Center(child: Text("No FAQs available."))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                      color: const Color(0xFFD9D9D9), width: 1),
                ),
                child: Column(
                  children: List.generate(_faqList.length, (index) {
                    final item = _faqList[index];
                    return Column(
                      children: [
                        _buildListTile(
                          index: index,
                          question: item["question"],
                          answer: item["answer"],
                        ),
                        Divider(height: 1),
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
    required String question,
    required String answer,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            _expandedStates[index]
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined,
            size: 25,
            color: Colors.black,
          ),
          onTap: () {
            setState(() {
              _expandedStates[index] = !_expandedStates[index];
            });
          },
        ),
        if (_expandedStates[index])
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}