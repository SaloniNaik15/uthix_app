import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHelpdesk extends StatefulWidget {
  const StudentHelpdesk({super.key});

  @override
  State<StudentHelpdesk> createState() => _StudentHelpdeskState();
}

class _StudentHelpdeskState extends State<StudentHelpdesk> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> submitQuery() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          duration: const Duration(seconds: 1),
          backgroundColor: Color(0xFF2B5C74),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');
      Dio dio = Dio();
      const String apiUrl =
          "https://admin.uthix.com/api/help-desks"; // 🔁 Replace this

      final response = await dio.post(
        apiUrl,
        data: {
          "subject": subject,
          "description": description,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Query submitted successfully!"),
            duration: const Duration(seconds: 1),
            backgroundColor: Color(0xFF2B5C74),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        _subjectController.clear();
        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Submission failed: $e"),
          duration: const Duration(seconds: 1),
          backgroundColor: Color(0xFF2B5C74),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: const Color(0xFF605F5F),
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 30,
              right: -10,
              child: Image.asset(
                'assets/icons/FrequentlyAsked Questions.png',
                width: 70.w,
                height: 70.h,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Help Desk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Please contact us \n"
                      " we will be happy to help you",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Spacer(),
                  Card(
                    child: Image.asset('assets/icons/HelpDesk.png',
                        width: 90, height: 90),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(height: 1),
              SizedBox(height: 20.h),
              Text("Raise a Query",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              const Divider(height: 1),
              SizedBox(height: 20.h),
              Text("Subject", style: TextStyle(fontSize: 14)),
              SizedBox(height: 10.h),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: "Start typing...",
                  filled: true,
                  hintStyle: TextStyle(fontSize: 14),
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: const Color(0xFFD2D2D2), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text("Description", style: TextStyle(fontSize: 14)),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Start Typing...',
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: const Color(0xFFD2D2D2), width: 1),
                  ),
                ),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
              ),
              SizedBox(height: 20.h),
              Container(
                alignment: Alignment.center,
                child: Text("We will answer your query asap.",
                    style: TextStyle(fontSize: 14)),
              ),
              SizedBox(height: 60.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 50.h,
                    width: 100.w,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF605F5F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading ? null : submitQuery,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                          : Text(
                              "Send",
                              style: TextStyle(
                                fontSize: 14,
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
