import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Frequentlyaskedquestions extends StatefulWidget {
  const Frequentlyaskedquestions({super.key});

  @override
  State<Frequentlyaskedquestions> createState() => _ManageFrequentlyaskedquestionsState();
}

class _ManageFrequentlyaskedquestionsState extends State<Frequentlyaskedquestions> {
  List<dynamic> faqs = [];
  List<bool> _expandedStates = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  // Fetch FAQ data using the stored token.
  Future<void> fetchFaqs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    const String faqApiUrl = "https://admin.uthix.com/api/faqs/active";
    try {
      final response = await Dio().get(
        faqApiUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          faqs = response.data; // Assuming the API returns a list.
          _expandedStates = List<bool>.filled(faqs.length, false);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint("Failed to load FAQs: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching FAQs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: const Color(0xFF605F5F),
                  size: 24.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 40,
              right: -10,
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
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xFFD9D9D9),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: List.generate(faqs.length, (index) {
                    final faq = faqs[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            faq["question"],
                            style:TextStyle(
                              fontSize: 14.sp,
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
                              _expandedStates[index] =
                              !_expandedStates[index];
                            });
                          },
                        ),
                        if (_expandedStates[index])
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              faq["answer"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        const Divider(height: 1),
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
}
