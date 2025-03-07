import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uthix_app/view/homeRegistration/otpPage.dart';
import 'package:uthix_app/view/login/main_combine.dart';

class PhoneOtp extends StatefulWidget {
  const PhoneOtp({super.key});

  @override
  State<PhoneOtp> createState() => _PhoneOtpState();
}

class _PhoneOtpState extends State<PhoneOtp> {
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents auto resizing
      body: Stack(
        children: [
          /// **Background Image (Full Screen)**
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset(
                "assets/registration/splash.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  /// **Back Button**
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  /// **Scrollable Content**
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// **Title**
                          Text(
                            "Type your Phone Number",
                            style: GoogleFonts.urbanist(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 40),

                          /// **Phone Input Field**
                          Row(
                            children: [
                              /// **Country Code**
                              Container(
                                height: 50,
                                width: 61,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(246, 246, 246, 1),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(210, 210, 210, 1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "+91",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color.fromRGBO(96, 95, 95, 1),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              /// **Phone Number Input**
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(246, 246, 246, 1),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          210, 210, 210, 1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _phonenoController,
                                      keyboardType: TextInputType.phone,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            const Color.fromRGBO(96, 95, 95, 1),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Phone Number",
                                        hintStyle: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(
                                              96, 95, 95, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 36,
                              width: 124,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(27, 97, 122, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Resend OTP",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          /// **OTP Section**
                          Text(
                            "Enter the OTP sent to\n your number",
                            style: GoogleFonts.urbanist(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, 1)),
                          ),

                          const SizedBox(height: 40),

                          /// **OTP Input Fields**
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(246, 246, 246, 1),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          210, 210, 210, 1),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: [
                                      _digit1Controller,
                                      _digit2Controller,
                                      _digit3Controller,
                                      _digit4Controller
                                    ][index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color.fromRGBO(96, 95, 95, 1),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            const Color.fromRGBO(96, 95, 95, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 40),

                          /// **Resend OTP & Request Call**
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _digit1Controller.clear();
                                _digit2Controller.clear();
                                _digit3Controller.clear();
                                _digit4Controller.clear();
                              });
                            },
                            child: Container(
                              height: 36,
                              width: 124,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(27, 97, 122, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Resend OTP",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
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

                  /// **"Submit" Button - Moves up when keyboard opens**
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const MainCombine()),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(27, 97, 122, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
        ],
      ),
    );
  }
}
