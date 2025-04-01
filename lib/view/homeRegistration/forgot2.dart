import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:uthix_app/view/homeRegistration/forgot3.dart';

class Forgot2 extends StatefulWidget {
  const Forgot2({super.key});

  @override
  State<Forgot2> createState() => _Forgot2State();
}

class _Forgot2State extends State<Forgot2> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();

  // FocusNodes for each digit field
  final FocusNode _digit1Focus = FocusNode();
  final FocusNode _digit2Focus = FocusNode();
  final FocusNode _digit3Focus = FocusNode();
  final FocusNode _digit4Focus = FocusNode();

  @override
  void dispose() {
    _digit1Controller.dispose();
    _digit2Controller.dispose();
    _digit3Controller.dispose();
    _digit4Controller.dispose();
    _digit1Focus.dispose();
    _digit2Focus.dispose();
    _digit3Focus.dispose();
    _digit4Focus.dispose();
    super.dispose();
  }

  Future<void> verifyCode() async {
    final digit1 = _digit1Controller.text.trim();
    final digit2 = _digit2Controller.text.trim();
    final digit3 = _digit3Controller.text.trim();
    final digit4 = _digit4Controller.text.trim();

    if (digit1.isEmpty || digit2.isEmpty || digit3.isEmpty || digit4.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete code")),
      );
      return;
    }

    final code = "$digit1$digit2$digit3$digit4";
    final dio = Dio();
    const String apiUrl = "https://admin.uthix.com/api/verify-otp";

    try {
      final response = await dio.post(apiUrl, data: {"code": code});

      if (response.statusCode == 200) {
        final isValid = response.data["valid"] ?? true;
        if (isValid) {
          // Code is correct: show success message and navigate
          final snackBar = SnackBar(content: Text("Code sent successfully"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Forgot3()),
            );
          });
        } else {
          // Code is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Code is incorrect")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code is incorrect")),
        );
      }
    } on DioException catch (dioError) {
      String errorMessage = "An error occurred";
      if (dioError.response != null) {
        errorMessage = "Error: ${dioError.response?.statusMessage}";
      } else {
        errorMessage = "Error: ${dioError.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }

  Widget _buildDigitField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
  }) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(
          color: const Color.fromRGBO(210, 210, 210, 1),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: GoogleFonts.urbanist(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color.fromRGBO(96, 95, 95, 1),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else if (value.isEmpty && previousFocus != null) {
            FocusScope.of(context).requestFocus(previousFocus);
          }
          if (value.length == 1 && nextFocus == null) {
            focusNode.unfocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Full-screen background image with opacity
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  "assets/registration/splash.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/registration/book.png",
                        width: 90.w,
                        height: 114.h,
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        "Please, check m**I@e*****e.com for your Verification Code",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(96, 95, 95, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      // Row of digit fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: _buildDigitField(
                              controller: _digit1Controller,
                              focusNode: _digit1Focus,
                              nextFocus: _digit2Focus,
                              previousFocus: null,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: _buildDigitField(
                              controller: _digit2Controller,
                              focusNode: _digit2Focus,
                              nextFocus: _digit3Focus,
                              previousFocus: _digit1Focus,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: _buildDigitField(
                              controller: _digit3Controller,
                              focusNode: _digit3Focus,
                              nextFocus: _digit4Focus,
                              previousFocus: _digit2Focus,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: _buildDigitField(
                              controller: _digit4Controller,
                              focusNode: _digit4Focus,
                              nextFocus: null,
                              previousFocus: _digit3Focus,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      // Verify button that calls verifyCode
                      GestureDetector(
                        onTap: verifyCode,
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: const Color.fromRGBO(27, 97, 122, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
